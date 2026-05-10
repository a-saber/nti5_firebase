import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/home/data/repo/tasks_repo.dart';
import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);

  var title = TextEditingController();
  var description = TextEditingController();
  DateTime? dateTime;
  onDateTimeChanged(DateTime newDateTime){
    dateTime = newDateTime;
    emit(AddTaskDateChangedState());
  }

  var formKey = GlobalKey<FormState>();

  TasksRepo repo = TasksRepo();

  void onAddTaskPressed() async {
    if (formKey.currentState?.validate() == false) return;

    emit(AddTaskLoadingState());
    var result = await repo.addTask(
        title: title.text,
        description: description.text,
        date: dateTime!
    );

    result.fold(
        (e)=> emit(AddTaskErrorState(e)),
        (u)=> emit(AddTaskSuccessState())
    );
  }
}
