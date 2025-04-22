package com.example.todo.Task;

import jakarta.validation.Valid;
import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = "/tasks")
public class TaskController {

    @Autowired
    private TaskRepository taskRepository;

    @GetMapping
    public List<TaskItem> getTasks(){
        return taskRepository.findAll();
    }
    @PostMapping
    public TaskItem addTask (@Valid @RequestBody TaskItem taskItem){
        System.out.println(taskItem.getTitle()); // Para verificar o valor de title
        return taskRepository.save(taskItem);
    }

    @PutMapping("/{id}")
    public ResponseEntity updateTask(@PathVariable Long id){
        boolean exist = taskRepository.existsById(id);
        if (exist){
            TaskItem task = taskRepository.getById(id);
            boolean done = task.isDone();
            task.setDone(!done);
            taskRepository.save(task);
            return new ResponseEntity<>("Task is updated", HttpStatus.OK);
        }
        return new ResponseEntity<>("Task is not exist", HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity deleteTask (@PathVariable Long id){
        boolean exist = taskRepository.existsById(id);
        if (exist){
            taskRepository.deleteById(id);
            return new ResponseEntity<>("Task is delete", HttpStatus.OK);
        }
        return new ResponseEntity<>("Task is not exist", HttpStatus.BAD_REQUEST);
    }
}
