import 'package:flutter/material.dart';

import 'package:notary/widgets/button_primary.dart';


class PolicyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Color(0xFF161617),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Please read and accept',
                style: TextStyle(
                  color: Color(0xFF161617),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Content',
                style: TextStyle(
                    color: Color(0xFF161617),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Text(
                'All text, graphics, user interfaces, visual interfaces, photographs, trademarks, logos, sounds, music, artwork and computer code (collectively, "Content"), including but not limited to the design, structure, selection, coordination, expression, "look and feel" and arrangement of such Content, contained on the Site is owned, controlled or licensed by or to Apple, and is protected by trade dress, copyright, patent and trademark laws, and various other intellectual property rights and unfair competition laws.',
                style: TextStyle(fontSize: 14, height: 1.8),
              ),
              SizedBox(height: 15),
              Text(
                'Except as expressly provided in these Terms of Use, no part of the Site and no Content may be copied, reproduced, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted or distributed in any way (including "mirroring") to any other computer, server, Web site or other medium for publication or distribution or for any commercial enterprise, without Apple’s express prior written consent.',
                style: TextStyle(fontSize: 14, height: 1.8),
              ),
              SizedBox(height: 80),
              Text(
                'Privacy',
                style: TextStyle(
                    color: Color(0xFF161617),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Text(
                'Apple’s Privacy Policy applies to use of this Site, and its terms are made a part of these Terms of Use by this reference. To view Apple’s Privacy Policy, click here. Additionally, by using the Site, you acknowledge and agree that Internet transmissions are never completely private or secure. You understand that any message or information you send to the Site may be read or intercepted by others, even if there is a special notice that a particular transmission (for example, credit card information) is encrypted.',
                style: TextStyle(fontSize: 14, height: 1.8),
              ),
              SizedBox(height: 80),
              Text(
                'Limitation of Liability',
                style: TextStyle(
                    color: Color(0xFF161617),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Text(
                'Except where prohibited by law, in no event will Apple be liable to you for any indirect, consequential, exemplary.',
                style: TextStyle(fontSize: 14, height: 1.8),
              ),
              SizedBox(height: 20),
              ButtonPrimary(
                text: 'Accept',
                callback: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
