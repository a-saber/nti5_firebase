import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/home/cubit/new_task/new_task_state.dart';
import 'package:nti5_firebase/features/home/data/models/task_model.dart';
import 'package:nti5_firebase/features/home/data/repo/tasks_repo.dart';

class NewTaskCubit extends Cubit<NewTaskState>{
  NewTaskCubit(this.repo) : super(NewTaskInitial());
  final TasksRepo repo;
  static NewTaskCubit get(context) => BlocProvider.of(context);

  var formKey = GlobalKey<FormState>();
  var title = TextEditingController();
  var description = TextEditingController();
  DateTime? dateTime;

  changeDateTime(DateTime dateTime){
    this.dateTime = dateTime;
    emit(NewTaskDateChanged());
  }

  addTask()async{
    if(formKey.currentState?.validate() == false) return;
    emit(NewTaskLoading());
    var result = await repo.addTask(task: TaskModel(
      title: title.text,
      description: description.text,
      dateTime: dateTime
    ));
    result.fold(
        (error)=> emit(NewTaskError(error)),
        (u)=> emit(NewTaskSuccess())
    );
  }
}