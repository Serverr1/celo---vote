import React from 'react'


export const Arguments = ( props ) => {

    return (
    <div>
  {props.argumentss.map((arg) =>(
    <div class="card" key={arg.index} >
    <div class="card-body">
      <p className="card-t">Topic: {arg.topic}</p>
  
      <div class="container">
    <div class="row">
      <div class="col-sm">
      <div class="card w-80" >
    <div class="card-body">
      <p class="card-text">{arg.arg1}</p>
    <div class="mb-0 mt-1">
    <button  onClick={()=>props.voteforArg1(arg.index)} class="btn btn-info mb-0 mt-1">Vote <span class="badge bg-secondary">{arg.arg1Votes}</span></button>
    </div>
  </div>
  </div>
      </div>
      <div class="col-sm">
      <div class="card w-80" >
    <div class="card-body">
    <p class="card-text">{arg.arg2}</p>
    <div class="mb-0 mt-1">
    <button onClick={ ()=> props.voteforArg2(arg.index)} class="btn btn-info mb-0 mt-1">Vote <span class="badge bg-secondary">{arg.arg2Votes}</span></button>
    </div>
  </div>
  </div>
      </div>
    </div>
  </div>
  
  
  </div>    
    </div>
  ))};
  </div>
    );
  }
  

  

