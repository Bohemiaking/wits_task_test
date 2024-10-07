import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wits_test/controllers/tasks_controller.dart';
import 'package:wits_test/data/models/tasks_model.dart';
import 'package:wits_test/screens/widgets/task_tile.dart';
import 'package:wits_test/utils/routes/routes.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final List<Tab> tabs = const [Tab(text: 'Pending'), Tab(text: 'Completed')];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksController = Get.find<TasksController>();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go(AppRoutes.addTask);
        },
        label: const Icon(Icons.add),
      ),
      bottomNavigationBar: Obx(
        () => (tasksController.selectedTask.isEmpty)
            ? const SizedBox.shrink()
            : BottomAppBar(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          tasksController.markSelectedTasksStatus();
                        },
                        child: tasksController
                                    .selectedTask.firstOrNull?.isCompleted ==
                                0
                            ? const Text('Mark completed')
                            : const Text('Mark pending')),
                    TextButton(
                        onPressed: () {
                          tasksController.deleteSelectedTasksStatus();
                        },
                        child: const Text('Delete selected')),
                  ],
                ),
              ),
      ),
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Good Morning,\nJohn',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(fontSize: 30),
                          ),
                        ),
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TabBar(
                    controller: tabController,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: tabs,
                    onTap: (value) {
                      tasksController.clearTaskSelectionMode();
                    },
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  Expanded(
                    child: (tasksController.isLoading.isTrue &&
                            tasksController.tasks.isEmpty)
                        ? const Center(
                            child: CircularProgressIndicator.adaptive())
                        : TabBarView(
                            viewportFraction: 1,
                            controller: tabController,
                            children: [
                              _buildTaskList(tasksController.tasks
                                  .where((task) => task.isCompleted == 0)
                                  .toList()),
                              _buildTaskList(tasksController.tasks
                                  .where((task) => task.isCompleted == 1)
                                  .toList()),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            if (tasksController.isUpdatingTask.isTrue) ...[
              Positioned.fill(
                  child: Container(
                color: Colors.white24,
                alignment: Alignment.center,
                child: const CircularProgressIndicator.adaptive(),
              ))
            ]
          ],
        ),
      ),
    );
  }

  // Widget to handle all task states: pending, and completed
  Widget _buildTaskList(List<TasksModel> tasks) {
    TasksController tasksController = Get.find();
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks available'));
    }
    return Column(
      children: [
        if (tasksController.tasks.isNotEmpty) ...[_buildSelectButton()],
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [for (var task in tasks) TaskTile(task: task)],
            ),
          ),
        ),
      ],
    );
  }

  // building select button for batch selection
  Widget _buildSelectButton() {
    TasksController tasksController = Get.find();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {
              tasksController.toggelTaskSelectionMode();
            },
            child: Text(tasksController.isTaskSelectionStarted.isTrue
                ? 'Cancel'
                : 'Select tasks')),
      ],
    );
  }
}
