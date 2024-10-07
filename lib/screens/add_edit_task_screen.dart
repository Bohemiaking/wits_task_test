import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';
import 'package:wits_test/controllers/tasks_controller.dart';
import 'package:wits_test/data/models/tasks_model.dart';
import 'package:wits_test/utils/constants/enums.dart';

class AddEdditTaskScreen extends StatefulWidget {
  final TasksModel? task;
  const AddEdditTaskScreen({super.key, this.task});

  @override
  State<AddEdditTaskScreen> createState() => _AddEdditTaskScreenState();
}

class _AddEdditTaskScreenState extends State<AddEdditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isEdit = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  TextEditingController _datePickerController = TextEditingController();

  @override
  void initState() {
    isEdit = widget.task != null ? true : false;

    _titleController = TextEditingController(text: widget.task?.title);
    _descController = TextEditingController(text: widget.task?.desc);
    _datePickerController = TextEditingController(text: widget.task?.deadline);
    _priorityController =
        TextEditingController(text: widget.task?.priority ?? '');

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priorityController.dispose();
    _datePickerController.dispose();

    super.dispose();
  }

  List priorities = [
    TaskPriority.high.name,
    TaskPriority.medium.name,
    TaskPriority.low.name
  ];

  @override
  Widget build(BuildContext context) {
    TasksController tasksController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Update task' : 'Add task'),
        actions: [
          if (isEdit) ...[
            Obx(() => IconButton(
                onPressed: tasksController.isUpdatingTask.isTrue
                    ? null
                    : () async {
                        bool result =
                            await tasksController.deleteTask(widget.task!);
                        if (result && context.mounted) {
                          context.pop();
                        }
                      },
                icon: const Icon(Icons.delete)))
          ]
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall,
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              const Gap(12),
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall,
                decoration: const InputDecoration(labelText: 'Description'),
                controller: _descController,
                minLines: 4,
                maxLines: 10,
              ),
              const Gap(12),
              TextfieldDatePicker(
                textfieldDatePickerMargin: const EdgeInsets.all(0),
                textfieldDatePickerPadding: const EdgeInsets.all(0),
                textfieldDatePickerWidth: double.infinity,
                textfieldDatePickerController: _datePickerController,
                style: Theme.of(context).textTheme.titleSmall,
                decoration: const InputDecoration(labelText: 'Deadline time'),
                materialDatePickerFirstDate:
                    DateTime.now().add(const Duration(days: 1)),
                materialDatePickerLastDate:
                    DateTime.now().add(const Duration(days: 90)),
                materialDatePickerInitialDate:
                    DateTime.now().add(const Duration(days: 1)),
                preferredDateFormat: DateFormat('yyyy-MM-dd'),
                cupertinoDatePickerMaximumDate:
                    DateTime.now().add(const Duration(days: 90)),
                cupertinoDatePickerMinimumDate:
                    DateTime.now().add(const Duration(days: 1)),
                cupertinoDatePickerBackgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                cupertinoDatePickerMaximumYear: 2025,
                cupertinoDateInitialDateTime:
                    DateTime.now().add(const Duration(days: 1)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select deadline time';
                  }
                  return null;
                },
              ),
              const Gap(12),
              DropdownButtonFormField<String>(
                value: _priorityController.text.isEmpty
                    ? null
                    : _priorityController.text,
                decoration:
                    const InputDecoration(label: Text('Select priority')),
                items: [
                  for (var item in priorities)
                    DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.toString().toUpperCase(),
                          style: Theme.of(context).textTheme.titleSmall,
                        )),
                ],
                onChanged: (value) {
                  _priorityController.text = value ?? '';
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select task priority';
                  }
                  return null;
                },
              ),
              const Gap(16),
              Obx(() => Row(
                    children: [
                      ElevatedButton(
                          onPressed: (tasksController.isAddingTask.isTrue ||
                                  tasksController.isUpdatingTask.isTrue)
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    TasksModel tasksModelData = TasksModel(
                                      title: _titleController.text,
                                      desc: _descController.text,
                                      deadline: _datePickerController.text,
                                      priority: _priorityController.text,
                                      isCompleted:
                                          widget.task?.isCompleted ?? 0,
                                      id: isEdit ? widget.task?.id : null,
                                    );
                                    bool result = isEdit
                                        ? await tasksController
                                            .updateTask(tasksModelData)
                                        : await tasksController
                                            .addTask(tasksModelData);
                                    if (result && context.mounted) {
                                      context.pop();
                                    }
                                  }
                                },
                          child: Text(isEdit ? 'Update' : 'Add')),
                      const Spacer(),
                      if (isEdit) ...[
                        TextButton(
                            onPressed: tasksController.isUpdatingTask.isTrue
                                ? null
                                : () async {
                                    bool result = await tasksController
                                        .markTaskStatus(widget.task!);
                                    if (result && context.mounted) {
                                      context.pop();
                                    }
                                  },
                            child: tasksController.isUpdatingTask.isTrue
                                ? const CircularProgressIndicator.adaptive()
                                : Text(widget.task?.isCompleted == 0
                                    ? 'Mark as completed'
                                    : 'Mark as pending'))
                      ]
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
