import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:invidious/controllers/settingsController.dart';
import 'package:invidious/globals.dart';
import 'package:invidious/views/tv/tvOverScan.dart';
import 'package:invidious/views/tv/tvSettings.dart';

import '../../../utils.dart';
import '../tvButton.dart';

class TvSearchHistorySettings extends StatelessWidget {
  const TvSearchHistorySettings({Key? key}) : super(key: key);

  void showClearHistoryDialog(BuildContext context) {
    var locals = AppLocalizations.of(context)!;

    showTvDialog(
        context: context,
        builder: (BuildContext context) => [
          Column(
            children: [
              Text(locals.clearSearchHistory, textScaleFactor: 3),
              Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Text(locals.irreversibleAction, textScaleFactor: 1.5),
              )
            ],
          ),
        ],
        actions: [
          TvButton(
            onPressed: (context) {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Text(locals.cancel),
            ),
          ),
          TvButton(
            onPressed: (context) async {
              db.clearSearchHistory();
              Navigator.of(context).pop();
            },
            focusedColor: Colors.red,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Text(locals.ok),
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locals = AppLocalizations.of(context)!;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: GetBuilder<SettingsController>(
        init: SettingsController(),
        global: false,
        builder: (_) => TvOverscan(
          child: ListView(
            children: [
              SettingsTitle(title: locals.searchHistoryDescription),
              SettingsTile(
                title: locals.enableSearchHistory,
                trailing: Switch(onChanged: (value) {}, value: _.useSearchHistory),
                onSelected: (ctx) => _.toggleSearchHistory(!_.useSearchHistory),
              ),
              SettingsTile(
                title: locals.searchHistoryLimit,
                description: locals.searchHistoryLimitDescription,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TvButton(
                          onPressed: (ctx) => _.useSearchHistory ? _.changeSearchHistoryLimit(increase: false) : null,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.remove),
                          )),
                    ),
                    Text(
                      _.searchHistoryLimit.toString(),
                      style: textTheme.bodyLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TvButton(
                          onPressed: (ctx) => _.useSearchHistory ? _.changeSearchHistoryLimit(increase: true) : null,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.add),
                          )),
                    ),
                  ],
                ),
              ),
              SettingsTile(
                title: locals.clearSearchHistory,
                trailing: const Icon(Icons.delete_forever),
                onSelected: (context) => showClearHistoryDialog(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
