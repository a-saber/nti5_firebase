import '../../data/models/task_model.dart';

abstract class GetTasksState {}

class GetTasksInitialState extends GetTasksState {}

class GetTasksLoadingState extends GetTasksState {}

class GetTasksSuccessState extends GetTasksState {
  List<TaskModel> tasks;
  GetTasksSuccessState(this.tasks);
}

class GetTasksErrorState extends GetTasksState {
  String error;
  GetTasksErrorState(this.error);
}