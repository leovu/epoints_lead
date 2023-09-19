

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lead_plugin_epoint/common/constant.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/container_scrollable.dart';
import 'package:lead_plugin_epoint/widget/custom_appbar.dart';
import 'package:lead_plugin_epoint/widget/custom_tab_bar.dart';

class CustomScaffold extends StatelessWidget {

  final Widget? body;
  final String? title;
  final Widget? customTitle;
  final List<CustomOptionAppBar>? options;
  final CustomRefreshCallback? onRefresh;
  final bool isBottom;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final List<KeyboardActionsItem>? actions;
  final IconData? icon;
  final List<CustomModelTabBar>? tabs;
  final TabController? tabController;
  final GestureTapCallback? onWillPop;
  final bool isBottomSheet;
  final bool isExpanded;
  final String? backgroundImage;

  CustomScaffold({
    this.body,
    this.title,
    this.customTitle,
    this.options,
    this.onRefresh,
    this.isBottom = false,
    this.backgroundColor,
    this.floatingActionButton,
    this.actions,
    this.icon,
    this.tabs,
    this.tabController,
    this.onWillPop,
    this.isBottomSheet = false,
    this.isExpanded = true,
    this.backgroundImage
  });

  Widget _buildContent(){
    return Column(
      children: [
        (title == null && customTitle == null)?Container():Container(
          height: 66,
          width: double.infinity,
          color: AppColors.primaryColor,
          padding: EdgeInsets.only(top: 10.0),
          child: CustomAppBar(
            title: title,
            customTitle: customTitle,
            options: options,
            icon: icon,
            onWillPop: onWillPop,
          ),
        ),
        tabs == null?Container():CustomTabBar(
          tabs: tabs,
          group: AutoSizeGroup(),
          controller: tabController,
          isExpanded: isExpanded,
        ),
        Expanded(
            child: tabs == null?ContainerScrollable(
                child: body,
                onRefresh: onRefresh
            ):CustomTabBarView(
              controller: tabController,
              tabs: tabs,
            )
        )
      ],
    );
  }

  Widget _buildBody(){
    return Scaffold(
        backgroundColor: backgroundColor??AppColors.white,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: backgroundImage == null
                ? _buildContent()
                : Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Container(
                    // width: AppSizes.maxWidth,
                    // height: AppSizes.maxHeight,
                    child: Image.asset(backgroundImage!, fit: BoxFit.fill,),
                  ),
                ),
                _buildContent()
              ],
            )
        ),),
        floatingActionButton: floatingActionButton,
        resizeToAvoidBottomInset: !isBottomSheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: configKeyboardActions(actions??[]),
      disableScroll: true,
      enable: Platform.isIOS || Platform.isMacOS,
      child: onWillPop == null
          ? _buildBody()
          : WillPopScope(
        child: _buildBody(),
        onWillPop: () async {
          onWillPop!();
          return false;
        },
      ),
    );
  }
}

configKeyboardActions(List<KeyboardActionsItem> actions) {
  return KeyboardActionsConfig(
      // keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      actions: actions);
}