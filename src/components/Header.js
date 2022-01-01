import React from 'react'


const Header = (props) => {
    return (
      <header className="header">

          <h1 className="brand-name">Celo Vote</h1>
          <nav>

            <span> <li><a className="balance"><span>{props.cUSDBalance}</span>cUSD</a></li>
            </span>
            </nav>
            <button type="button" className="btn btn-info" onClick={props.onAdd}>Add a Topic</button>
         
    </header>
    
    );
  };
  
  export default Header;