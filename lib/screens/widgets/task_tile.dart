import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wits_test/controllers/tasks_controller.dart';
import 'package:wits_test/data/models/tasks_model.dart';
import 'package:wits_test/utils/constants/enums.dart';
import 'package:wits_test/utils/helpers/random_color_denerator.dart';
import 'package:wits_test/utils/routes/routes.dart';

class TaskTile extends StatefulWidget {
  final TasksModel task;
  const TaskTile({super.key, required this.task});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    TasksController tasksController = Get.find();

    Color priorityColor = widget.task.priority == TaskPriority.high.name
        ? Colors.red
        : widget.task.priority == TaskPriority.medium.name
            ? Colors.amber
            : Colors.green;
    Color randomColor = generateRandomColor();

    return Obx(() => InkWell(
          onTap: () {
            if (tasksController.isTaskSelectionStarted.isTrue) {
              tasksController.selectTask(widget.task);
            } else {
              context.go(AppRoutes.editTask, extra: widget.task);
            }
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: randomColor.withOpacity(0.02),
                ),
                child: Row(
                  children: [
                    if (tasksController.isTaskSelectionStarted.isTrue) ...[
                      Checkbox.adaptive(
                          value: tasksController.selectedTask
                              .contains(widget.task),
                          onChanged: (v) {
                            tasksController.selectTask(widget.task);
                          }),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: priorityColor,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "${widget.task.priority} priority"
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontSize: 10, color: priorityColor),
                              ),
                              const Spacer(),
                              Text(
                                'End on ${widget.task.deadline}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 10,
                                color: Colors.black54,
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.task.title ?? '',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Gap(2),
                          Text(
                            widget.task.desc ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              )
            ],
          ),
        ));
  }
}
