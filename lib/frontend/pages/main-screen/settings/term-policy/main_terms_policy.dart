import 'package:flutter/material.dart';

import '../../../../../resources/schema/texts.dart';
import '../../../../widgets/terms_policyBtn.dart';

class TermsPolicy extends StatelessWidget {
  
  const TermsPolicy({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CategoryText(
          text: "Terms & Policy"
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: ListView(
          children: [
            TermsPolicyBtn(
              title: 'Terms of Service',
              svgIcon: 'lib/resources/svg/documents.svg',
              navigateTo: 'TermsService',
              description: 'Terms you accept by using SafeZone.',
            ),
            TermsPolicyBtn(
              title: 'Privacy Policy',
              svgIcon: 'lib/resources/svg/lock.svg',
              navigateTo: 'PrivacyPolicy',
              description: 'The information we collect and how it is used.',
            ),
            TermsPolicyBtn(
              title: 'Community Standards',
              svgIcon: 'lib/resources/svg/police.svg',
              navigateTo: 'CommunityStandards',
              description: 'Prohibited actions and how to report misconduct.',
            ),
          ],
        ),
      )
    );
  }
}