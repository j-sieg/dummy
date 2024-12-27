class ExpenseDestroyer
  def destroy(expense, destroy_option)
    case destroy_option
    when "this_instance"
      if expense.update(disabled_at: Time.current)
        Result.new(success: true, expense: expense)
      else
        Result.new(success: true, expense: expense)
      end
    when "all_instances"
      if Expense.where(purpose: expense.purpose).delete_all > 0
        Result.new(success: true, expense: expense, deleted_all_instances: true)
      else
        Result.new(success: false, expense: expense)
      end
    end
  end

  class Result
    attr_reader :expense

    def initialize(success:, expense: nil, deleted_all_instances: false)
      @success = success
      @expense = expense
      @deleted_all_instances = deleted_all_instances
    end

    def success?
      @success
    end

    def deleted_all_instances?
      @deleted_all_instances
    end
  end
end
