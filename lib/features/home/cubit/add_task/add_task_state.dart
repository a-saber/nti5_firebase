
abstract class AddTaskState {}

class AddTaskInitialState extends AddTaskState {}
class AddTaskDateChangedState extends AddTaskState {}

class AddTaskLoadingState extends AddTaskState {}

class AddTaskSuccessState extends AddTaskState {}
class AddTaskErrorState extends AddTaskState {
  final String error;
  AddTaskErrorState(this.error);
}