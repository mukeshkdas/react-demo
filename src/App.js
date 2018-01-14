import React from 'react';
import './App.css';


class App extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      greeting: "Hello"
    };
  }

  render() {
    const message = "message";
    return (
      <div className="App" >
        <div>
          <h1 id="greeting">{this.state.greeting} World !</h1>
        </div>
      </div >
    );
  }
}

export default App;
