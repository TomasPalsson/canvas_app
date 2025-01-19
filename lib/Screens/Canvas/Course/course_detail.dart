import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/canvas/tab_widget.dart';
import '../../../Components/custom_tab.dart';
import '../../../Components/loading_enum.dart';
import '../../../Models/Canvas/course.dart';
import '../../../Models/Canvas/course_tab.dart';
import '../../../Providers/assingment_provider.dart';
import '../../../Providers/module_provider.dart';
import '../../../Providers/tab_provider.dart';
import '../../../Providers/theme_provider.dart';
import '../../../Screens/Canvas/Assignments/all_assignments_list.dart';
import '../../../Screens/Canvas/modules/all_module_list.dart';
import '../../../Screens/flashcards/flashcard_list_screen.dart';

class CourseDetail extends StatefulWidget {
  final Course course;
  const CourseDetail({super.key, required this.course});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  List<CourseTab> tabs = [];

  bool loading = true;

  List<CustomTab> customTabs = [];

  void _getCustomTabs() {
    customTabs = [
      CustomTab(
        label: 'Assignments',
        icon: Icons.assignment,
        color: widget.course.color,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllAssignmentsList(course: widget.course),
            ),
          );
        },
        course: widget.course,
      ),
      CustomTab(
        label: 'Modules',
        icon: Icons.book,
        color: widget.course.color,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllModuleList(course: widget.course),
            ),
          );
        },
        course: widget.course,
      ),
      CustomTab(
        label: 'Flashcards',
        icon: Icons.style,
        color: widget.course.color,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlashcardListScreen(course: widget.course),
            ),
          );
        },
        course: widget.course,
      ),
    ];
  }

  Future<void> _getData() async {
    tabs = await TabProvider.getTabs(widget.course);
    setState(() {
      loading = false;
    });
    Provider.of<ModuleProvider>(context, listen: false)
        .fetchModules(widget.course.id);
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _getCustomTabs();
    Provider.of<AssignmentProvider>(context, listen: false)
        .getAssignments(widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.course.color,
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: widget.course.color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.course.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          SizedBox(height: 30),
          loading
              ? Center(
                  child: Provider.of<ThemeProvider>(context, listen: false)
                      .loadingWidget
                      .widget,
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: tabs.length + customTabs.length,
                    itemBuilder: (context, index) {
                      if (index < customTabs.length) {
                        return TabWidget(customTab: customTabs[index]);
                      } else {
                        return TabWidget(
                            courseTab: tabs[index - customTabs.length]);
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
