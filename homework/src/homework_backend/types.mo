import Time "mo:base/Time";
import Bool "mo:base/Bool";

module  {
    public type Homework = {
        title: Text;
        description: Text;
        dueDate: Time.Time;
        completed: Bool;
    };
};
