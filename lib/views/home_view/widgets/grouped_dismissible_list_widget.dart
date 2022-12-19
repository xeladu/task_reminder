import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/widgets/dismissible_task_widget.dart';
import 'package:task_reminder/widgets/action_button_widget.dart';
import 'package:task_reminder/widgets/wrapper_widget.dart';

class GroupedDismissibleListWidget extends StatefulWidget {
  final Map<String, List<Task>> items;
  final Function(Task) onDismissed;
  final Future<bool?> Function(Task) onConfirmDismiss;
  final Function(Task)? onLongPress;
  final Function(Task) onTap;

  const GroupedDismissibleListWidget(
      {Key? key,
      required this.items,
      required this.onDismissed,
      required this.onTap,
      required this.onConfirmDismiss,
      this.onLongPress})
      : super(key: key);

  @override
  State<GroupedDismissibleListWidget> createState() =>
      _GroupedDismissibleListWidgetState();
}

class _GroupedDismissibleListWidgetState
    extends State<GroupedDismissibleListWidget> {
  final List<String> _hiddenCategories = <String>[];

  @override
  Widget build(BuildContext context) {
    return GroupListView(
        padding: EdgeInsets.zero,
        groupHeaderBuilder: (context, section) {
          final sectionName = widget.items.keys.toList()[section];
          final sectionItemCount = widget.items[sectionName]!.length;
          final isHidden = _hiddenCategories.contains(sectionName);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: WrapperWidget(
                backgroundColor: AppColors.appBackgroundSecondary,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sectionName, style: TextStyles.subHeading),
                            Text("$sectionItemCount tasks",
                                style: TextStyles.label)
                          ]),
                      ActionButtonWidget(
                          onPressed: () {
                            if (isHidden) {
                              _hiddenCategories.remove(sectionName);
                            } else {
                              _hiddenCategories.add(sectionName);
                            }

                            setState(() {});
                          },
                          icon: isHidden
                              ? FontAwesomeIcons.anglesDown
                              : FontAwesomeIcons.anglesUp)
                    ])),
          );
        },
        sectionsCount: widget.items.keys.length,
        countOfItemInSection: (section) =>
            widget.items.values.toList()[section].length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, entry) {
          final section = widget.items.keys.toList()[entry.section];

          if (_hiddenCategories.contains(section)) return const SizedBox();

          final item = widget.items[section]![entry.index];
          return DismissibleTaskWidget(
              onLongPress: () => widget.onLongPress!(item),
              onConfirmDismiss: (dir) => widget.onConfirmDismiss(item),
              onDismissed: (dir) => widget.onDismissed(item),
              task: item,
              onTap: () => widget.onTap(item),
              hideCategory: true);
        });
  }
}
