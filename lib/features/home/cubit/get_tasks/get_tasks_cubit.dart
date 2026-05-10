import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/home/data/repo/tasks_repo.dart';

import 'get_tasks_state.dart';

class GetTasksCubit extends Cubit<GetTasksState>{
  GetTasksCubit() : super(GetTasksInitialState());
  static GetTasksCubit get(context)=> BlocProvider.of(context);
  TasksRepo repo = TasksRepo();
  getTasks()async{
    emit(GetTasksLoadingState());
    var result = await repo.getTasks();
    result.fold(
        (e)=> emit(GetTasksErrorState(e)),
        (tasks)=> emit(GetTasksSuccessState(tasks))
    );
  }
}