//const API_URL = "http://localhost:8000";
const API_URL = "https://api.cloudriann.com"; // adjust for container setup
const notesDiv = document.getElementById("notes");
const noteForm = document.getElementById("noteForm");

async function fetchNotes() {
  notesDiv.innerHTML = "";
  const res = await fetch(`${API_URL}/notes`);
  const notes = await res.json();

  notes.forEach(note => {
    const noteEl = document.createElement("div");
    noteEl.className = "note";

    noteEl.innerHTML = `
      <div class="note-details">
        <h3>${note.title}</h3>
        <p>${note.description}</p>
        <p>Status: ${note.done ? "✅ Done" : "❌ Not Done"}</p>
      </div>
      <div class="note-actions">
        <button class="edit-btn" onclick="editNote('${note.id}')">✏️ Edit</button>
        <button class="delete-btn" onclick="deleteNote('${note.id}')">🗑️ Delete</button>
      </div>
    `;
    notesDiv.appendChild(noteEl);
  });
}

async function addNote(e) {
  e.preventDefault();
  const title = document.getElementById("title").value;
  const description = document.getElementById("description").value;
  const done = document.getElementById("done").checked;

  await fetch(`${API_URL}/note`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ title, description, done })
  });

  noteForm.reset();
  fetchNotes();
}

async function deleteNote(id) {
  await fetch(`${API_URL}/note/${id}`, { method: "DELETE" });
  fetchNotes();
}


async function editNote(id) {
  const newTitle = prompt("Enter new title (leave blank to keep current):");
  const newDescription = prompt("Enter new description (leave blank to keep current):");
  const newDone = confirm("Mark as done?");

  const updateData = {};

  // Only set if user typed something (not null, not empty, not spaces)
  if (newTitle !== null && newTitle.trim() !== "") {
    updateData.title = newTitle.trim();
  } else {
    // If user left it blank, we don't include title in updateData
    // This way, the backend won't change the title
  }
  if (newDescription !== null && newDescription.trim() !== "") {
    updateData.description = newDescription.trim();
  }

  // Always include done if you want to allow toggling
  updateData.done = newDone;

  // Only send if we actually have something to update
  if (Object.keys(updateData).length > 0) {
    await fetch(`${API_URL}/note/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(updateData)
    });
  }

  fetchNotes();
}



noteForm.addEventListener("submit", addNote);
fetchNotes();
