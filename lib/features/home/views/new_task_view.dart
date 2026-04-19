import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nti5_firebase/features/home/cubit/new_task/new_task_cubit.dart';
import 'package:nti5_firebase/features/home/cubit/new_task/new_task_state.dart';
import 'package:nti5_firebase/features/home/data/repo/tasks_repo.dart';

class NewTaskView extends StatelessWidget {
  const NewTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> NewTaskCubit(TasksRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('New Task'),
        ),
        body: BlocConsumer<NewTaskCubit, NewTaskState>(
          listener:  (context, state) {
            if(state is NewTaskError){
              Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            else if(state is NewTaskSuccess){
              Fluttertoast.showToast(
                  msg: 'Task Added Successfully',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            var cubit= NewTaskCubit.get(context);
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children:
                [
                  TextFormField(
                    controller: cubit.title,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Title is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  SizedBox(height: 20,),

                  TextFormField(
                    controller: cubit.description,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  SizedBox(height: 20,),

                  TextFormField(
                    controller: TextEditingController(
                      text: cubit.dateTime?.toString()??''
                    ),
                    readOnly: true,
                    onTap: ()async{
                      var newDateTime = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365))
                      );
                      if(newDateTime !=null){
                        cubit.changeDateTime(newDateTime);
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  if(state is NewTaskLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(onPressed: cubit.addTask, child: Text('Add Task'))

                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
