class Api::Shared::NotesController < Api::Controller
  before_filter :fetch_note, only: [:show, :destroy]

  def index
    kind = params.require(:kind)
    @notes = paginate(scoped_notes.by_kind(kind), params)
  end

  def show
    note = Note.find(params[:id])
    render json: { id: note.id, kind: note.kind, source: note.source, text: note.text, status: note.status }, status: :ok
  end

  def create
    note = construct_note
    if note.save
      render status: :created, json: {id: note.id}
    else
      error_response :unprocessable_entity, note.errors
    end
  end

  def destroy
    if @note.deactivate!
      render nothing: true, status: :ok
    else
      error_response :unprocessable_entity, @note.errors
    end
  end

  protected

  def construct_note
    s = Note.new(note_params)
    s.user = current_user
    s
  end

  def fetch_note
    @note = current_user.notes.visible.find params[:id]
  end

  def note_params
    params.require(:note).permit([:kind, :source, :text])
  end

  def scoped_notes
    current_user.notes.visible
  end
end
