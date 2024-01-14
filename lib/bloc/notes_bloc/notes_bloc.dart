import 'package:bloc/bloc.dart';
import 'package:notes_app/bloc/notes_bloc/notes_events.dart';
import 'package:notes_app/bloc/notes_bloc/notes_state.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/notes_repository.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({required this.notesRepository}) : super(NotesInitialState(notes: [])) {
    on<NotesLoadEvent>((event, emit) async {
      List<Note> notes = await notesRepository.loadNotes();

      emit(NotesLoadedState(notes: notes));
    });

    // events that handle the note page
    on<NotesLoadCreateNotePageEvent>((event, emit) => emit(NotesCreateNoteState()));

    on<NotesDeleteEvent>((event, emit) async {
      await notesRepository.deleteNote(event.note);

      emit(NotesLoadedState(notes: await notesRepository.loadNotes()));
    });

    on<NotesLoadNotePageEvent>((event, emit) {
      emit(NotesOpenNoteState(note: event.note));
    });
  }

  NotesRepository notesRepository;
}
