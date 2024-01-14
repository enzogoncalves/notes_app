import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes_app/bloc/notes_bloc/notes_events.dart';
import 'package:notes_app/bloc/notes_bloc/notes_state.dart';
import 'package:notes_app/models/color.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/pages/note/create_note_page.dart';
import 'package:notes_app/pages/note/note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: appColors.mainTextColor,
          title: const Text(
            "Notes",
          ),
          backgroundColor: appColors.backgroundColor,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                ),
                style: IconButton.styleFrom(backgroundColor: appColors.appBarIconBackgroundColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            )
          ],
        ),
        backgroundColor: appColors.backgroundColor,
        body: Container(
            padding: const EdgeInsets.all(10),
            child: BlocListener<NotesBloc, NotesState>(
                listener: (context, state) {
                  if (state is NotesOpenNoteState) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(value: context.read<NotesBloc>(), child: const NotePage()),
                    ));
                  }
                },
                child: BlocBuilder<NotesBloc, NotesState>(buildWhen: (context, state) {
                  return state is NotesInitialState || state is NotesLoadedState || state is NotesCreateNoteState;
                }, builder: (context, state) {
                  if (state is NotesInitialState) {
                    return Center(
                      child: CircularProgressIndicator(color: appColors.mainTextColor),
                    );
                  } else if (state is NotesLoadedState) {
                    List<Note> notes = state.notes;

                    if (notes.isEmpty) {
                      return Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/no_data.svg',
                                  width: 200,
                                  height: 200,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Create a new note and it will be displayed here",
                                  style: TextStyle(color: appColors.mainTextColor, fontSize: 20, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: goToCreateNotePageButton(),
                          ),
                        ],
                      );
                    } else {
                      return Stack(
                        children: [
                          ListView.separated(
                            itemCount: notes.length,
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                context.read<NotesBloc>().add(NotesLoadNotePageEvent(note: notes[index]));
                              },
                              child: Dismissible(
                                key: UniqueKey(),
                                background: Container(
                                  color: appColors.mainRedColor,
                                  child: Align(
                                    alignment: const Alignment(-0.9, 0),
                                    child: Icon(
                                      Icons.delete,
                                      color: appColors.mainTextColor,
                                    ),
                                  ),
                                ),
                                direction: DismissDirection.startToEnd,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  height: 60,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(color: appColors.dismissibleNoteBackgroundColor, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                                  child: Text(
                                    notes[index].title ?? "Notes title empty",
                                    style: TextStyle(color: appColors.mainTextColor, fontSize: 18),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  context.read<NotesBloc>().add(NotesDeleteEvent(note: notes[index]));
                                },
                              ),
                            ),
                          ),
                          Positioned(bottom: 20, right: 20, child: goToCreateNotePageButton()),
                        ],
                      );
                    }
                  } else if (state is NotesSearchState) {
                    return const Text("data");
                  } else {
                    return const Text("Error...");
                  }
                }))));
  }

  Widget goToCreateNotePageButton() {
    return IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                    value: context.read<NotesBloc>(),
                    child: const CreateNotePage(),
                  )));
        },
        icon: const Icon(Icons.add),
        iconSize: 50,
        color: appColors.mainTextColor,
        style: IconButton.styleFrom(backgroundColor: appColors.foregroundBlueColor));
  }
}
