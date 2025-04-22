package com.example.todo.Task;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;

@Entity
public class TaskItem {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @NotBlank(message = "title is required")
    private String title;

    private boolean done;

    public TaskItem(long id, String title, boolean done) {
        this.id = id;
        this.title = title;
        this.done = done;
    }
    public TaskItem() {
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public boolean isDone() {
        return done;
    }

    public void setDone(boolean done) {
        this.done = done;
    }
}
