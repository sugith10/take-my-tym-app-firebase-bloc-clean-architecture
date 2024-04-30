import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:take_my_tym/core/widgets/app_bottom_sheet.dart';
import 'package:take_my_tym/core/widgets/auth_padding.dart';
import 'package:take_my_tym/features/control_panel/presentation/pages/accept_offer_page.dart';
import 'package:take_my_tym/features/control_panel/presentation/widgets/contract_timeline_widget.dart';
import 'package:take_my_tym/features/control_panel/presentation/widgets/offer_list_tile.dart';
import 'package:take_my_tym/features/control_panel/presentation/widgets/panel_title_widget.dart';

class ProposalsTab extends StatelessWidget {
  const ProposalsTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AuthPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelTitleWidget(
            title: 'Offers',
          ),
          OfferListTile(
            text: 'Lorem Ipsum is simply dummy text of the',
            onPressed: () {
              Navigator.push(context, AcceptOfferPage.route());
            },
          ),
          SizedBox(height: 20.h),
          const PanelTitleWidget(
            title: 'Submitted proposals',
          ),
          OfferListTile(
            text: 'Lorem Ipsum is simply dummy text of the',
            onPressed: () {
              _showBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      children: [
        Text(
          'Proposal status',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 2.h),
        const TimeLineTileWidget(
          isFirst: true,
          isLast: false,
          isPast: true,
          text: 'Succefully submited',
        ),
        const TimeLineTileWidget(
          isFirst: false,
          isLast: true,
          isPast: false,
          text: "Waiting for confirmation",
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
