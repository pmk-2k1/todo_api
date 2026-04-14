class TasksController < ApplicationController
  before_action :authorize!

  def index
    if current_user.admin?
      tasks = Task.all
    else
      tasks = current_user.tasks
    end
    render json: tasks
  end

  def create
    task = current_user.tasks.build(task_params)
    task.save
    render json: task
  end

  def update
    task = Task.find(params[:id])
    if current_user.admin? || task.user == current_user
      task.update(task_params)
      render json: task
    else
      render json: { error: "Forbidden" }, status: 403
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy if current_user.admin? || task.user == current_user
    head :no_content
  end

  private

  def task_params
    params.permit(:title, :description, :status, :time_start, :time_end)
  end
end
