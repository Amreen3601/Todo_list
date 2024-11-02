import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Controllers/todo_controller.dart';
import 'package:todo_app/Models/To_do.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/constants/custom_appbar.dart';
import 'package:todo_app/constants/custom_textfeilds.dart';
import 'package:todo_app/constants/custom_textstyles.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Todo List',
        titleTextStyle: MyTextStyles.appBarTitle,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'Uncompleted'),
          ],
          labelColor: AppColors.whiteColor,
          unselectedLabelColor: AppColors.textColor,
          indicatorColor: AppColors.whiteColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodoList(context, (todo) => true),
          _buildTodoList(context, (todo) => todo.completed),
          _buildTodoList(context, (todo) => !todo.completed),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoList(BuildContext context, bool Function(Todo) filter) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        print("Rebuilding TodoListScreen"); // Debug print

        final filteredTodos = provider.todos.where(filter).toList();
        return ListView.builder(
          itemCount: filteredTodos.length,
          itemBuilder: (_, index) {
            final todo = filteredTodos[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(todo.title, style: MyTextStyles.style1),
                        IconButton(
                          icon: Icon(
                            todo.completed
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: todo.completed
                                ? AppColors.greenColor
                                : AppColors.grayColor,
                          ),
                          onPressed: () {
                            provider.updateTodo(
                              Todo(
                                id: todo.id,
                                title: todo.title,
                                description: todo.description,
                                completed: !todo.completed,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(todo.description, style: MyTextStyles.style2),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: AppColors.blueColor),
                          onPressed: () => _showTodoDialog(
                            context,
                            isEditing: true,
                            todo: todo,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: AppColors.redColor),
                          onPressed: () => provider.deleteTodoById(todo.id),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTodoDialog(BuildContext context,
      {bool isEditing = false, Todo? todo}) {
    final provider = Provider.of<TodoProvider>(context, listen: false);

    // Set initial values if editing
    provider.titleController.text = todo?.title ?? '';
    provider.descriptionController.text = todo?.description ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Edit Todo Item' : 'Add Todo Item',
            style: MyTextStyles.style3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: provider.titleController,
              hintText: 'Enter Title',
              labelText: 'Title',
              labelStyle: MyTextStyles.style4,
              isBorder: true,
            ),
            SizedBox(height: 12),
            CustomTextField(
              controller: provider.descriptionController,
              hintText: 'Enter Description',
              labelText: 'Description',
              labelStyle: MyTextStyles.style4,
              isBorder: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: MyTextStyles.style5),
          ),
          TextButton(
            onPressed: () {
              final title = provider.titleController.text;
              final description = provider.descriptionController.text;

              if (title.isNotEmpty && description.isNotEmpty) {
                if (isEditing && todo != null) {
                  provider.updateTodo(Todo(
                    id: todo.id,
                    title: title,
                    description: description,
                    completed: todo.completed,
                  ));
                } else {
                  provider.addTodo(
                    context,
                    Todo(
                      id: DateTime.now().toString(),
                      title: title,
                      description: description,
                      completed: false,
                    ),
                  );
                }
                provider.titleController.clear();
                provider.descriptionController.clear();
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text(isEditing ? 'Edit' : 'Add'),
          ),
        ],
      ),
    );
  }
}
