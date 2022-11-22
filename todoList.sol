// SPDX-License-Identifier: Unlicensed

pragma solidity <=0.9.0;

contract TodoList {
    struct Todo {
        string Title;
        bool completed;
    }

    Todo[] public todos;

    function set(string calldata _title) public {
        todos.push(Todo({Title: _title, completed: false}));
    }

    function updateText(uint _index, string calldata _title) public {
        todos[_index].Title = _title;
    }

    function get(uint _index) public view returns (string memory, bool) {
        return (todos[_index].Title, todos[_index].completed);
    }
}
