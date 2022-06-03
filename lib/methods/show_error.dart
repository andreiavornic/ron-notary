import 'package:notary/controllers/authentication.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/auth.dart';
import 'package:notary/views/errors/error_page.dart';
import 'package:notary/views/start.dart';
import 'package:provider/provider.dart';

import '../views/server_not_response.dart';
import '../views/session_expired.dart';

showError(err, context) {
  if (err == 'JWT EXPIRED' || err == 'TOKEN NULL') {
    StateM(context).navOff(SessionExpired());
    return;
  } else if (err == "SERVE_NOT_RESPONSE") {
    StateM(context).navOff(ServerNotResponse());
    return;
  } else if (err == 'Session not found') {
    StateM(context).navTo(ErrorPage(
      errorMessage: "This session was closed, please check eJournal",
      callback: () => StateM(context).navOff(Start()),
    ));

    return;
  }

  StateM(context).navTo(ErrorPage(
    errorMessage: err.toString(),
    callback: () => StateM(context).navBack(),
  ));
}
