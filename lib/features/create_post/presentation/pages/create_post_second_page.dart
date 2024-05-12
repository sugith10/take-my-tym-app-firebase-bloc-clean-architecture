import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:take_my_tym/core/utils/app_error_msg.dart';

import '../../../../core/model/app_post_model.dart';
import '../../../../core/navigation/screen_transitions/right_to_left.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/home_padding.dart';
import '../../../../core/widgets/loading_dialog.dart';
import '../../../../core/widgets/skills_widget/bloc/create_skill_bloc/create_skill_bloc.dart';
import '../../../../core/widgets/skills_widget/create_skills_widget.dart';
import '../../../../core/widgets/success_widget/success_page.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../navigation_menu/presentation/pages/app_navigation_menu.dart';
import '../../../view_post/presentation/bloc/read_post_bloc/read_post_bloc.dart';
import '../bloc/create_post_bloc/create_post_bloc.dart';
import '../bloc/update_post_bloc/update_post_bloc.dart';
import '../widgets/create_page_app_bar.dart';
import '../widgets/create_post_form_widget.dart';

class CreatePostSecondPage extends StatefulWidget {
  final PostModel? postModel;
  final CreatePostBloc bloc;
  const CreatePostSecondPage({required this.bloc, this.postModel, super.key});

  static route(
          {required PostModel? postModel,
          required CreatePostBloc createPostBloc}) =>
      rightToLeft(
        CreatePostSecondPage(
          bloc: createPostBloc,
          postModel: postModel,
        ),
      );
  @override
  State<CreatePostSecondPage> createState() => _CreatePostSecondPageState();
}

class _CreatePostSecondPageState extends State<CreatePostSecondPage> {
  final TextEditingController categoryCntrl = TextEditingController();
  final TextEditingController experienceCntrl = TextEditingController();
  final TextEditingController remunerationCntrl = TextEditingController();
  final LocationBloc locationBloc = LocationBloc();
  final CreateSkillBloc createSkillBloc = CreateSkillBloc();
  List<dynamic>? skills;
  final AppErrorMsg errorMsg = AppErrorMsg(
      title: "Missing required fields",
      content: "Please fill in all fields to create a post.");

  @override
  void initState() {
    super.initState();
    if (widget.postModel != null) {
      experienceCntrl.text = widget.postModel!.skillLevel;
      remunerationCntrl.text = widget.postModel!.price.toString();
      skills = widget.postModel!.skills;
    }
  }

  @override
  void dispose() {
    categoryCntrl.dispose();
    experienceCntrl.dispose();
    remunerationCntrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void colletInfo() {
      final createSkillState = createSkillBloc.state;
      final locationState = locationBloc.state;
      if (createSkillState is UpdateSkillSuccessState &&
          locationState is LocationResultState) {
        if (widget.postModel == null) {
          widget.bloc.add(
            CreateSecondPageEvent(
              experience: experienceCntrl.text,
              location: locationState.placeName,
              remuneration: remunerationCntrl.text,
              skills: createSkillState.skills,
              latitude: locationState.latitude,
              longitude: locationState.longitude,
            ),
          );
        } else {
          context.read<UpdatePostBloc>().add(
                UpdateSecondPageEvent(
                  experience: experienceCntrl.text,
                  location: locationState.placeName,
                  remuneration: remunerationCntrl.text,
                  skills: createSkillState.skills,
                  latitude: locationState.latitude,
                  longitude: locationState.longitude,
                ),
              );
        }
      } else {
        AppSnackBar.failSnackBar(context: context, error: errorMsg);
      }
    }

   
    return MultiBlocListener(
      listeners: [
        BlocListener(
            bloc: widget.bloc,
            listener: (context, state) {
              if (state is CreatPostLoadingState) {
                LoadingDialog().show(context);
              }
              if (state is CreateSecondFailState) {
                Navigator.pop(context);
                AppSnackBar.failSnackBar(
                  context: context,
                  error: state.error,
                );
              }
              if (state is CreatePostSuccessState) {
                state.refreshType
                    ? context
                        .read<GetPostsBloc>()
                        .add(GetBuyTymPostsEvent(userId: state.uid))
                    : context
                        .read<GetPostsBloc>()
                        .add(GetSellTymPostsEvent(userId: state.uid));
                Navigator.pushAndRemoveUntil(
                  context,
                  SuccessPage.route(pop: false),
                  (route) => false,
                );
              }
            }),
        BlocListener<UpdatePostBloc, UpdatePostState>(
          listener: (context, state) {
            if (state is UpdatePostLoadingState) {
              LoadingDialog().show(context);
            } else if (state is UpdatePostFailState) {
              Navigator.pop(context);
              AppSnackBar.failSnackBar(
                context: context,
                error: state.error,
              );
            } else if (state is UpdatePostSuccessState) {
              state.refreshType
                  ? context
                      .read<GetPostsBloc>()
                      .add(GetBuyTymPostsEvent(userId: state.uid))
                  : context
                      .read<GetPostsBloc>()
                      .add(GetSellTymPostsEvent(userId: state.uid));
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationMenu(),
                ),
                (route) => false,
              );
            }
          },
        )
      ],
      child: Scaffold(
        appBar: CreatePageAppBar(
          next: false,
          actionCall: () {
            FocusManager.instance.primaryFocus?.unfocus();
            colletInfo();
          },
        ),
        body: HomePadding(
            child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  CollectItemsWidget(
                    createSkillBloc: createSkillBloc,
                  ),
                  SizedBox(height: 10.h),
                  CreatePostFormWidget(
                    locationBloc: locationBloc,
                   
                    experienceCntrl: experienceCntrl,
                    remunerationCntrl: remunerationCntrl,
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
