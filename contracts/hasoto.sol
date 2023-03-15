// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract hasoto {
    event NewLetter(uint256 _points);

    struct Letter {
        address from;
        address to;
        uint256 points;
        uint256 time;
        string text;
    }
    Letter[] public letters;
    mapping(address => uint256) public lastTime;
    
    function postLetter(address _to, string memory _text) external {
        require(msg.sender != _to);
        require(bytes(_text).length <= 64);
        uint256 _points = timePoints(_to);
        uint256 _time = block.timestamp;
        Letter memory _myLetter;
        _myLetter.from = msg.sender;
        _myLetter.to = _to;
        _myLetter.points = _points;
        _myLetter.time = _time;
        _myLetter.text = _text;
        letters.push(_myLetter);
        lastTime[_to] = _time;
        assert(_points != 0);
        emit NewLetter(_points);
    }

    function totalPoints(address _adr, uint256 startNumber) external view returns (uint256)
    {
        uint256 _point = 0;
        uint256 _num = letters.length;
        for (uint256 i = startNumber; i < _num; i++) {
            if (letters[i].from == _adr || letters[i].to == _adr) {
                _point = _point + letters[i].points;
            }
        }
        return (_point);
    }

    function totalLetters() external view returns (uint256) {
        uint256 _num = letters.length;
        return (_num);
    }

    function timePoints(address _adr) public view returns (uint256) {
        uint256 _time = lastTime[_adr];
        uint256 _points;
        if (_time == 0) {
            _points = 1;
        } else {
            _points = ((block.timestamp - _time) / 1 hours) + 1;
        }
        if (_points < 1) {
            _points = 1;
        }
        return (_points);
    }
}
