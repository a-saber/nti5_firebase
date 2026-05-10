import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nti5_firebase/features/home/cubit/add_task/add_task_cubit.dart';

import '../cubit/add_task/add_task_state.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Task'),
        ),
        body: BlocConsumer<AddTaskCubit, AddTaskState>(
            listener: (context, state) {
          if (state is AddTaskSuccessState) {
            Fluttertoast.showToast(
                msg:
                    "Task Added Successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pop(context);
          } else if (state is AddTaskErrorState) {
            Fluttertoast.showToast(
                msg: state.error,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: AddTaskCubit.get(context).formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title',
                    ),
                    controller: AddTaskCubit.get(context).title,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Description',
                    ),
                    controller: AddTaskCubit.get(context).description,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (selectedDate != null) {

                        var time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if(time != null){
                          selectedDate = selectedDate.add(Duration(hours: time.hour, minutes: time.minute));
                          AddTaskCubit.get(context)
                              .onDateTimeChanged(selectedDate);
                        }
                      }


                    },
                    decoration: InputDecoration(
                      hintText: 'Date',
                    ),
                    controller: TextEditingController(
                        text: AddTaskCubit.get(context).dateTime == null
                            ? ''
                            : AddTaskCubit.get(context).dateTime.toString()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  state is AddTaskLoadingState
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: AddTaskCubit.get(context).onAddTaskPressed,
                          child: Text('Add Task')),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
