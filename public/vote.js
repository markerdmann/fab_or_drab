//Global variable to hold all data
fob={};
fob.images={};
fob.images.current=0;
//How many extra images to buffer
fob.images._minBufferLength=4;
fob.images._maxBufferLength=15;
fob.images._extendQueue=function(){
	//Fetch more images and append them to images.data array
}
fob.images.next=function(){
	var i=(++this.current);
	
	//IF no images left at all, then wait till queue is extended
	if(this.data.length <= this.current){
		//Don't draw until callback
	}
	
	//Check to see if we need to add more to the queue
	if(this.data.length <= (this.current+this._minBufferLength)){
		this._extendQueue();
	}
	
	return this.data[i];
}

$(document).ready(function(){
	var $imgCont=$('div.image');
	//Do ajax call for images or some shit....
	fob.images.data=[
		{'url':'images/sample1.jpg'},
		{'url':'images/sample2.jpg'},
		{'url':'images/sample3.jpg'},
		{'url':'images/sample4.jpg'}				
	];
	$('.button').click(function(){
		//Button action
		var $img=$imgCont.find('img');
		
		$img.animate({
			left:"-140%"
		},{
			duration:400,
			complete:function(){
				$img.remove();
			}
		});
		
		(function(){
			var img=fob.images.next();
			//Wait a bit before sliding in the next one
			var $nextImg=$img.clone().attr('src',img.url).appendTo($imgCont);
			console.log($nextImg,img, $imgCont);
		})();
	});
});