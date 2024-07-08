// app/javascript/controllers/task_list_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["tasks", "template"]

    addTask(event) {
        event.preventDefault()
        console.log("task_list#addTask")
        const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
        this.tasksTarget.insertAdjacentHTML('beforeend', content)
    }

    removeTask(event) {
        event.preventDefault()
        console.log("task_list#removeTask")
        const item = event.target.closest(".nested-fields")
        if (item.dataset.newRecord === "true") {
            item.remove()
        } else {
            item.querySelector("input[name*='_destroy']").value = "1"
            item.style.display = "none"
        }
    }
}
