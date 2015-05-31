class TasksController < ApplicationController
	skip_before_filter  :verify_authenticity_token
	# before_action :require_login

	def index
		p session[:user_id]
		task = Task.where(family_id: session[:user_id])
	end

	def create
		p params
		@task = Task.new
		@task.point_value = params[:points]
		@task.title = params[:title]
		@task.family_id = current_user.id
		@task.assigned_member_id = params[:name]
		if @task.save
			render json: @task
		end
	end

	def destroy
		p "hello"
		@task = Task.find_by(id: params[:id])
		if @task.destroy
			all_tasks = Task.all
			render json: all_tasks
		end
	end

	def kid_complete
		task = Task.find_by(id: params[:task_id])
		task.completed_member_id = task.assigned_member_id
		task.save
	end


	def parent_complete
		task = Task.find_by(id: params[:task_id])
		member = Member.find_by(id: params[:task_id])
		task.complete = true
		member.task_points += task.point_value
		member.save
	end

	def parent_delete
		task = Task.find_by(id: params[:task_id])
		task.delete
		task.save
	end

	def parent_redo
		task = Task.find_by(id: params[:task_id])
		task.completed_member_id = nil
		task.save
	end

	private
	def task_params
		params.require(:task).permit :title, :points, :name, :deadline
	end

	def require_login
		if !current_user

		end
	end
end
