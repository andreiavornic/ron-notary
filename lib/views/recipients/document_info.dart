import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/document_pop_up.dart';
import 'package:provider/provider.dart';

class DocumentInfo extends StatefulWidget {
  @override
  _DocumentInfoState createState() => _DocumentInfoState();
}

class _DocumentInfoState extends State<DocumentInfo> {

  @override
  Widget build(BuildContext context) {
   return Consumer<SessionController>(builder: (context, _sessionController, _){
     return Container(
       decoration: BoxDecoration(
           color: Color(0xFFF6F6F9), borderRadius: BorderRadius.circular(6)),
       child: Padding(
         padding: const EdgeInsets.all(15.0),
         child: Row(
           children: [
             Expanded(
               child: Row(
                 children: [
                   Container(
                     width: reSize(context, 54),
                     height: reSize(context, 72),
                     decoration: BoxDecoration(
                       border: Border.all(
                         width: 1,
                         color: Color(0xFF000000).withOpacity(0.07),
                       ),
                       borderRadius: BorderRadius.circular(5),
                     ),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(5),
                       child: TextButton(
                         style: ButtonStyle(
                           padding: MaterialStateProperty.all(EdgeInsets.zero),
                         ),
                         onPressed: () =>StateM(context).navTo(DocumentPopUp()),
                         child: Image.memory(
                           base64Decode(
                               Provider.of<SessionController>(context, listen: false).session.images[0]),
                         ),
                       ),
                     ),
                   ),
                   SizedBox(width: 30),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         width: StateM(context).width() - 200,
                         child: Text(Provider.of<SessionController>(context, listen: false).session.sessionFileName,
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                             color: Color(0xFF000000),
                             fontSize: 14,
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ),
                       SizedBox(height: 5),
                       Container(
                         width: StateM(context).width() - 200,
                         child: Text(
                           'Type: ${Provider.of<SessionController>(context, listen: false).session.typeNotarization.name}',
                           // overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                             color: Color(0xFFA4A4A4),
                             fontSize: 12,
                           ),
                         ),
                       )
                     ],
                   )
                 ],
               ),
             ),
           ],
         ),
       ),
     );
   });
  }
}
