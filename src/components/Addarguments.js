import React from 'react'

import { useState } from "react";

export const Addarguments = (props) => {


 const [topic, setTopic] = useState('');
 const [arg1, setArg1] = useState('');
 const [arg2, setArg2] = useState('');

 const submitHandler = (e) => {
  e.preventDefault();

  if(!topic || !arg1 || !arg2) {
    alert('Please complete all fields')
    return
  }
  props.addArgument(topic, arg1, arg2);

  setTopic('')
  setArg1('')
  setArg2('')
};




    return (
<>
<div className='mb-2'>
<form onSubmit={submitHandler} >
  <div class="form-group">
    <label className='form-label' >Topic</label>
    <input type="text"
           className="form-control"
           value={topic}
           onChange={(e) => setTopic(e.target.value)}
           placeholder="topic" />
  </div>
  <div class="form-group">
    <label className='form-label'>First Argument</label>
    <input type="text" 
           className="form-control"
           value={arg1}
           onChange={(e) => setArg1(e.target.value)}
           placeholder="first argument" />
  </div>
  <div class="form-group">
    <label className='form-label'>Second Argument</label>
    <input type="text" 
           className="form-control"
           value={arg2}
           onChange={(e) => setArg2(e.target.value)}
           placeholder="second argument" />
  </div>
  <button type="submit" class="btn btn-info">Submit</button>
</form>
</div>
  </>      
           
    )
}
export default Addarguments;