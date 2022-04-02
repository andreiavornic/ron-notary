import 'package:flutter/material.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';

class ParticipantBuffer {
  final bool audioEnabled;
  final String id;

  ParticipantBuffer({
    @required this.audioEnabled,
    @required this.id,
  });
}

class ParticipantWidget extends StatelessWidget {
  final Widget child;
  final String id;
  final bool audioEnabled;
  final bool videoEnabled;
  final bool isRemote;
  final bool isActive;
  final bool isDummy;
  final bool isDominant;
  final bool audioEnabledLocally;
  final NetworkQualityLevel networkQualityLevel;
  final Stream<NetworkQualityLevelChangedEvent> onNetworkQualityChanged;
  final Color color;

  const ParticipantWidget({
    Key key,
    @required this.child,
    @required this.audioEnabled,
    @required this.videoEnabled,
    @required this.isActive,
    @required this.id,
    @required this.isRemote,
    this.networkQualityLevel =
        NetworkQualityLevel.NETWORK_QUALITY_LEVEL_UNKNOWN,
    this.onNetworkQualityChanged,
    this.audioEnabledLocally = true,
    this.isDominant = false,
    this.isDummy = false,
    this.color = const Color(0xFFFFC700),
  }) : super(key: key);

  ParticipantWidget copyWith({
    Widget child,
    bool audioEnabled,
    bool videoEnabled,
    bool isDominant,
    bool audioEnabledLocally,
    bool isActive,
  }) {
    return ParticipantWidget(
      id: id,
      audioEnabled: audioEnabled ?? this.audioEnabled,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      isDominant: isDominant ?? this.isDominant,
      audioEnabledLocally: audioEnabledLocally ?? this.audioEnabledLocally,
      isRemote: isRemote,
      networkQualityLevel: networkQualityLevel,
      onNetworkQualityChanged: onNetworkQualityChanged,
      child: child ?? this.child,
      isActive: isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
