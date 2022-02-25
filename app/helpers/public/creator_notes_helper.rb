module Public::CreatorNotesHelper
  def show_name_in_anonymity?(creator_note)
    (creator_note.requester != creator_note.user) && (creator_note.is_annonymous == true) && (creator_note.requester != current_user)
  end
end
