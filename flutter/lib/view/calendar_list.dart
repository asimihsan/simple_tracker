// ============================================================================
//  Copyright 2020 Asim Ihsan. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License in the LICENSE file and at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
// ============================================================================

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/localizations.dart';
import 'package:simple_tracker/state/calendar_list_model.dart';
import 'package:simple_tracker/state/calendar_repository.dart';
import 'package:simple_tracker/state/calendar_summary_model.dart';
import 'dart:developer' as developer;

import 'package:simple_tracker/state/user_model.dart';
import 'package:simple_tracker/view/calendar_detail.dart';
import 'package:simple_tracker/view/create_edit_calendar_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget getCalendarList(BuildContext context) {
  final AppLocalizations localizations =
      Localizations.of<AppLocalizations>(context, AppLocalizations);
  final CalendarListModel calendarListModel = Provider.of<CalendarListModel>(context, listen: true);

  final Color addButtonColor = calendarListModel.isCombinedView ? Colors.grey : Colors.blue;
  final VoidCallback onAddCallback = calendarListModel.isCombinedView
      ? null
      : () async {
          developer.log("Create new calendar click");
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => getCreateEditCalendar(context, isCreate: true)),
          );
        };

  return Scaffold(
    appBar: AppBar(
      title: Text(calendarListModel.isCombinedView
          ? localizations.calendarListCombinedViewTitle
          : localizations.calendarListTitle),
    ),
    body: SafeArea(
      child: new CalendarList(),
//      minimum: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
    floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0)),
        FloatingActionButton(
          child: SvgPicture.asset("assets/icons/MultipleCalendars.svg",
              semanticsLabel: localizations.calendarListCombinedViewTitle),
          backgroundColor: Colors.lightGreen,
          onPressed: () {
            developer.log("Combined view");
            calendarListModel.toggleIsCombinedView();
          },
          heroTag: null,
        ),
        Padding(padding: const EdgeInsets.fromLTRB(0, 0, 16.0, 0)),
        FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: addButtonColor,
          onPressed: onAddCallback,
          heroTag: null,
          disabledElevation: 0.0,
        ),
      ],
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );
}

class CalendarList extends StatefulWidget {
  static CalendarListState of(BuildContext context) =>
      context.findAncestorStateOfType<CalendarListState>();

  @override
  State<StatefulWidget> createState() {
    return new CalendarListState();
  }
}

Future<List<CalendarSummaryModel>> refreshListCalendars(BuildContext context) {
  final CalendarRepository calendarRepository =
      Provider.of<CalendarRepository>(context, listen: false);
  final UserModel userModel = Provider.of<UserModel>(context, listen: false);
  final CalendarListModel calendarListModel =
      Provider.of<CalendarListModel>(context, listen: false);
  return calendarRepository.listCalendars(
      userId: userModel.userId,
      sessionId: userModel.sessionId,
      calendarListModel: calendarListModel);
}

Future<void> deleteCalendar(String calendarId, BuildContext context) {
  final CalendarRepository calendarRepository =
      Provider.of<CalendarRepository>(context, listen: false);
  final UserModel userModel = Provider.of<UserModel>(context, listen: false);
  return calendarRepository
      .deleteCalendar(
          userId: userModel.userId, sessionId: userModel.sessionId, calendarId: calendarId)
      .then((_) {
    return refreshListCalendars(context);
  }).catchError((error) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Failed to delete calendar!!")));
  });
}

class CalendarListState extends State<CalendarList> with AfterLayoutMixin<CalendarList> {
  final SlidableController slidableController = SlidableController();

  @override
  void afterFirstLayout(BuildContext context) {
    developer.log("CalendarList afterFirstLayout");
    refreshListCalendars(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarListModel>(builder: (context, calendarList, child) {
      if (calendarList == null || calendarList.loading == true) {
        return emptyList(context, "Loading...");
      }
      final List<CalendarSummaryModel> calendarSummaries =
          calendarList.getCalendarSummariesInNameOrder();
      if (calendarSummaries.length == 0) {
        return emptyList(context, "You don't have any calendars!");
      }
      List<Widget> children = new List();
      if (calendarList.isCombinedView) {
        children.add(Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          child: Text(
            "Select up to 4 calendars to view at the same time.",
            style: Theme.of(context).textTheme.headline6,
          ),
        ));
        children.add(Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            child: RaisedButton(
                onPressed: () async {
                  if (calendarList.getCombinedViewCalendarsAsList().length == 0) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("No calendars selected!"),
                        backgroundColor: Colors.deepOrange));
                    return;
                  }
                  final List<CalendarSummaryModel> calendarSummaryModels =
                      calendarList.getCombinedViewCalendarsAsList();
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              getCalendarDetail(calendarSummaryModels, readOnly: true)));
                  calendarList.toggleIsCombinedView();
                },
                child: Text('Show in combined view'))));
      }
      children.addAll(calendarList.getCalendarSummariesInNameOrder().map((calendarSummary) =>
          calendarSummaryModelToListViewWidget(calendarList, calendarSummary, context)));
      return new RefreshIndicator(
          onRefresh: () {
            developer.log("refresh for non-empty!");
            if (calendarList.isCombinedView) {
              calendarList.isCombinedView = false;
            }
            return refreshListCalendars(context);
          },
          child: Container(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: children,
              )));
    });
  }

  Widget emptyList(BuildContext context, String text) {
    return new RefreshIndicator(
        onRefresh: () {
          developer.log("refresh for empty!");
          return refreshListCalendars(context);
        },
        child: Container(
            padding: const EdgeInsets.all(32.0),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[new Text(text)],
            )));
  }

  Widget calendarSummaryModelToListViewWidget(CalendarListModel calendarListModel,
      CalendarSummaryModel calendarSummaryModel, BuildContext context) {
    final Widget listTile = ListTile(
      leading: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(color: calendarSummaryModel.color),
      ),
      title: Text(calendarSummaryModel.name),
      onLongPress: () {
        calendarListModel.toggleIsCombinedView();
        calendarListModel.selectCalendarForCombinedView(calendarSummaryModel);
      },
      onTap: () {
        if (!calendarListModel.isCombinedView) {
          slidableController.activeState?.close();
          final List<CalendarSummaryModel> calendarSummaryModels = new List();
          calendarSummaryModels.add(calendarSummaryModel);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => getCalendarDetail(calendarSummaryModels, readOnly: false)));
          return;
        }

        if (calendarListModel.isCalendarSelectedInCombinedView(calendarSummaryModel)) {
          calendarListModel.deselectCalendarForCombinedView(calendarSummaryModel);
        } else {
          calendarListModel.selectCalendarForCombinedView(calendarSummaryModel);
        }
      },
    );

    final Widget card = calendarListModel.isCombinedView &&
            calendarListModel.isCalendarSelectedInCombinedView(calendarSummaryModel)
        ? Card(child: listTile, color: Colors.black12)
        : Card(child: listTile);

    final Widget slidable = Slidable(
      key: Key(calendarSummaryModel.id),
      controller: slidableController,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: card,
      actions: <Widget>[
        IconSlideAction(
            caption: 'Edit',
            color: Colors.black45,
            icon: Icons.edit,
            onTap: () {
              developer.log("Edit: " + calendarSummaryModel.name);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => getCreateEditCalendar(context,
                        isCreate: false, existingCalendarSummaryModel: calendarSummaryModel)),
              );
            }),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => {
                  showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete'),
                          content:
                              Text('Calendar ' + calendarSummaryModel.name + ' will be deleted'),
                          actions: <Widget>[
                            FlatButton.icon(
                              icon: Icon(Icons.arrow_back, color: Colors.black45),
                              label: Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            FlatButton.icon(
                              icon: Icon(Icons.delete, color: Colors.red),
                              label: Text('Ok'),
                              onPressed: () {
                                calendarListModel.loading = true;
                                final NavigatorState navigatorState = Navigator.of(context);
                                deleteCalendar(calendarSummaryModel.id, context).then((_) {
                                  navigatorState.pop(true);
                                }).catchError((err) {
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text("Failed to delete calendar!!")));
                                  calendarListModel.loading = false;
                                });
                              },
                            )
                          ],
                        );
                      })
                }),
      ],
    );

    // If we're in combined view mode then don't bother letting the user edit or delete calendars.
    if (calendarListModel.isCombinedView) {
      return card;
    }

    return slidable;
  }
}
