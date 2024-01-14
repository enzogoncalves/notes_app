import 'package:bloc/bloc.dart';
import 'package:notes_app/bloc/note_bloc/note_events.dart';
import 'package:notes_app/bloc/note_bloc/note_state.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/notes_repository.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc({required this.notesRepository}) : super(NoteInitialState()) {
    on<NoteCreatedEvent>((event, emit) async {
      emit(NoteCreateInProgessState());

      Note note = Note(title: event.title, text: event.text);

      notesRepository.createNote(note).then((value) {
        emit(NoteCreatedState());
      }).catchError((onError) {
        emit(NoteCreateErrorState());
      });
    });

    on<NoteEditingInProgressEvent>((event, emit) => emit(NoteEditInProgressState()));

    on<NoteEditEvent>((event, emit) async {
      await notesRepository.editNote(event.note);

      emit(NoteEditedState());
    });

    on<NoteDeleteEvent>((event, emit) async {
      await notesRepository.deleteNote(event.note);

      emit(NoteDeletedState());
    });

    on<NoteReturnToInitialStateEvent>((event, emit) => emit(NoteInitialState()));
  }

  NotesRepository notesRepository;
}
