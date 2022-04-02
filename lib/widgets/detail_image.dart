import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notary/utils/navigate.dart';

import 'package:notary/widgets/title_page.dart';

class DetailImage extends StatelessWidget {
  final String imgPath;
  final Function deleteImg;

  DetailImage(this.imgPath, this.deleteImg);

  @override
  Widget build(BuildContext context) {
    _deleteImg() {
      deleteImg();
      return Navigator.pop(context);
    }

    ColorFilter greyscale = ColorFilter.matrix(<double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        width: StateM(context).width(),
        height: StateM(context).height(),
        child: Stack(
          children: [
            Container(
              width: StateM(context).width(),
              height: StateM(context).height(),
              child: ColorFiltered(
                colorFilter: greyscale,
                child: Image.file(
                  File(imgPath),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            TitlePage(
              title: "",
              description: "",
              needNav: true,
            ),
            Container(
              child: Positioned(
                bottom: 40,
                left: StateM(context).width() / 2 - 56,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFCF3F3),
                      ),
                      child: InkWell(
                        overlayColor: MaterialStateProperty.all(
                          Color(0xFFE37A7A).withOpacity(0.56),
                        ),
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onTap: _deleteImg,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            // color: Color(0xFFFCF3F3),
                          ),
                          child: Center(
                              child: Icon(
                            Icons.delete_forever,
                            size: 24,
                            color: Color(0xFFE37A7A),
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
