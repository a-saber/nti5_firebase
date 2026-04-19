abstract class NewTaskState{}

class NewTaskInitial extends NewTaskState{}

class NewTaskLoading extends NewTaskState{}

class NewTaskDateChanged extends NewTaskState{}

class NewTaskSuccess extends NewTaskState{}

class NewTaskError extends NewTaskState{
  final String message;
  NewTaskError(this.message);
}