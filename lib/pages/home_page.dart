import 'package:flutter/material.dart';
import 'package:habittracker/components/month_summary.dart';
import 'package:habittracker/data/habit_database.dart';
import 'package:hive/hive.dart';

import '../components/habit_tile.dart';
import '../components/my_alert_box.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('Habit_Database');

  @override
  void initState() {
    //if there is no current habit list, then it is the 1st time ever opening the app
    //then create default data
    if (_myBox.get('CURRENT_HABIT_LIST') == null) {
      db.createDefaultDatabase();
    }

    //if there is current habit list, then it is not the 1st time ever opening the app
    //then load existing data
    else {
      db.loadData();
    }

    //update database
    db.updateDatabase();

    super.initState();
  }

  //checkbox was tapped
  void checkboxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value!;
    });
    //update database
    db.updateDatabase();
  }

  //create new habit
  final _newHabitController = TextEditingController();

  void createNewHabit() {
    //show alert dialog for user to enter the new habit details
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newHabitController,
            onSave: saveNewHabit,
            onCancel: cancelDialogBox,
            hintText: 'Add new habit',
          );
        });
  }

  //save new habit
  void saveNewHabit() {
    //add new habit to today's habit list
    setState(() {
      _newHabitController.text.trim() == ''
          ? ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add some task!'),
          action: SnackBarAction(
              label: 'Ok',
              onPressed: () {
                createNewHabit();
              }),
        ),
      )
          : db.todaysHabitList.add([_newHabitController.text.trim(), false]);
    });
    //clear textField
    _newHabitController.clear();
    //pop dialog box
    Navigator.of(context).pop();
    //update database
    db.updateDatabase();
  }

  //cancel new habit
  void cancelDialogBox() {
    //clear textField
    _newHabitController.clear();
    //pop dialog box
    Navigator.of(context).pop();
  }

  //change existing habit
  void changeExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitController.text.trim();
    });
    //clear textField
    _newHabitController.clear();
    //pop dialog box
    Navigator.of(context).pop();
    //update database
    db.updateDatabase();
  }

  //delete existing habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    //update database
    db.updateDatabase();
  }

  //open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newHabitController,
            onSave: () => changeExistingHabit(index),
            onCancel: cancelDialogBox,
            hintText: db.todaysHabitList[index][0],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => createNewHabit(),
        ),
        backgroundColor: Colors.grey[300],
        body: ListView(
          children: [
            //Monthly summary
            MonthlySummary(
              startDate: _myBox.get('START_DATE'),
              datasets: db.heatMapDataSet,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
                itemCount: db.todaysHabitList.length,
                itemBuilder: (context, index) {
                  return HabitTile(
                    habitName: db.todaysHabitList[index][0],
                    habitStatus: db.todaysHabitList[index][1],
                    onChanged: (value) => checkboxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                  );
                }),
            //List view
          ],
        ));
  }
}
