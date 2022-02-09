import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/twilio/views/participant.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:uuid/uuid.dart';

class TwilioController extends GetxController {
  Room _room;
  final Completer<Room> _completer = Completer<Room>();
  final List<StreamSubscription> _streamSubscriptions = [];
  var _participants = <ParticipantWidget>[].obs;

  RxList<ParticipantWidget> get participants => _participants;

  @override
  void dispose() {
    _disposeStreamsAndSubscriptions();
    super.dispose();
  }

  @override
  void onClose() {
    onHangup();
    super.onClose();
  }

  final StreamController<bool> _onAudioEnabledStreamController =
      StreamController<bool>.broadcast();
  Stream<bool> onAudioEnabled;
  final StreamController<bool> _onVideoEnabledStreamController =
      StreamController<bool>.broadcast();
  Stream<bool> onVideoEnabled;

  final StreamController<Exception> _onExceptionStreamController =
      StreamController<Exception>.broadcast();

  Stream<Exception> onException;
  final StreamController<NetworkQualityLevel>
      _onNetworkQualityStreamController =
      StreamController<NetworkQualityLevel>.broadcast();

  void _onConnected(Room room) {
    print("_onConnected() => Executed!");
    print("room.localParticipant ${room.localParticipant}");
    _streamSubscriptions
        .add(_room.onParticipantConnected.listen(_onParticipantConnected));
    _streamSubscriptions.add(
        _room.onParticipantDisconnected.listen(_onParticipantDisconnected));
    _completer.complete(_room);
    final localParticipant = room.localParticipant;
    print("localParticipant ${localParticipant.identity}");
    if (localParticipant == null) {
      return;
    }

    _participants.add(
      new ParticipantWidget(
        child: localParticipant.localVideoTracks[0].localVideoTrack.widget(),
        id: localParticipant.identity,
        audioEnabled: true,
        videoEnabled: true,
        networkQualityLevel: localParticipant.networkQualityLevel,
        onNetworkQualityChanged: localParticipant.onNetworkQualityLevelChanged,
        isActive: false,
        isRemote: false,
      ),
    );

    print("_participants.length ${_participants.length}");

    update();
  }

  void _onConnectFailure(RoomConnectFailureEvent event) {
    print(
        'Failed to connect to room ${event.room.name} with exception: ${event.exception}');
    _completer.completeError(event.exception);
  }

  String getToken() {
    final box = GetStorage();
    return box.read('TWILIO_TOKEN');
  }

  Future<Room> connectToRoom(String roomName) async {
    try {
      var trackId = Uuid().v4();
      var accessToken = getToken();
      var cameraSources = await CameraSource.getSources();
      var cameraCapturer = CameraCapturer(
        cameraSources.firstWhere((source) => source.isFrontFacing),
      );

      var connectOptions = ConnectOptions(
        accessToken,
        roomName: roomName,
        // Optional name for the room
        preferredAudioCodecs: [OpusCodec()],
        audioTracks: [LocalAudioTrack(true, 'audio_track-$trackId')],
        dataTracks: [
          LocalDataTrack(
            DataTrackOptions(name: 'data_track-$trackId'),
          )
        ],
        videoTracks: ([LocalVideoTrack(true, cameraCapturer)]),
        enableNetworkQuality: true,
        networkQualityConfiguration: NetworkQualityConfiguration(
          remote: NetworkQualityVerbosity.NETWORK_QUALITY_VERBOSITY_MINIMAL,
        ),
        enableDominantSpeaker: true,
      );
      _room = await TwilioProgrammableVideo.connect(connectOptions);
      _room.onConnected.listen(_onConnected);
      _room.onConnectFailure.listen(_onConnectFailure);
      return _completer.future;
    } catch (err) {
      throw err;
    }
  }

  Future<void> _disposeStreamsAndSubscriptions() async {
    await _onAudioEnabledStreamController.close();
    await _onVideoEnabledStreamController.close();
    await _onExceptionStreamController.close();
    await _onNetworkQualityStreamController.close();
    for (var streamSubscription in _streamSubscriptions) {
      await streamSubscription.cancel();
    }
  }

  Future<void> onHangup() async {
    try {
      if (_room == null) {
        return;
      }
      await _room.disconnect();
    } catch (err) {
      throw err;
    }
  }

  void _onParticipantConnected(RoomParticipantConnectedEvent event) {
    print(event);
    _addRemoteParticipantListeners(event.remoteParticipant);
  }

  void _onParticipantDisconnected(RoomParticipantDisconnectedEvent event) {
    _participants.removeWhere(
        (ParticipantWidget p) => p.id == event.remoteParticipant.identity);
    update();
    //   notifyListeners();
  }

  _addRemoteParticipantListeners(RemoteParticipant remoteParticipant) {
    print("remoteParticipant $remoteParticipant");
  }



  ParticipantWidget getParticipant(String id) {
    return _participants.firstWhere((element) => element.id == id,
        orElse: () => new ParticipantWidget(
            child: Container(),
            audioEnabled: true,
            videoEnabled: true,
            isActive: false,
            id: id,
            isRemote: true));
    // return _participants[0];
  }

  Future<void> toggleMute(RemoteParticipant remoteParticipant) async {
    final enabled = await remoteParticipant
        .remoteAudioTracks.first.remoteAudioTrack
        .isPlaybackEnabled();
    remoteParticipant.remoteAudioTracks
        .forEach((remoteAudioTrackPublication) async {
      final remoteAudioTrack = remoteAudioTrackPublication.remoteAudioTrack;
      if (remoteAudioTrack != null && enabled != null) {
        await remoteAudioTrack.enablePlayback(!enabled);
      }
    });

    var index = _participants.indexWhere((ParticipantWidget participant) =>
        participant.id == remoteParticipant.identity);
    if (index < 0) {
      return;
    }
    _participants[index] =
        _participants[index].copyWith(audioEnabledLocally: !enabled);
    update();
  }
}
