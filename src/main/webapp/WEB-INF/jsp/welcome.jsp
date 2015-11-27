<!DOCTYPE html>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html lang="en">
<head>
   <title>How to Start with dhtmlxGantt</title>
   <script src="${pageContext.request.contextPath}/resources/js/dhtmlxgantt.js"></script>   
   <script src="${pageContext.request.contextPath}/resources/js/dhtmlxgantt_marker.js"></script>   
   
   <link href="${pageContext.request.contextPath}/resources/css/dhtmlxgantt.css" rel="stylesheet">   
   
   		<style>
.weekend{ background: #f4f7f4 !important;}
#title1{
  padding-left:35px;
  color:black;
  font-weight:bold;
}
#title2{
  padding-left:15px;
  color:black;
  font-weight:bold;
}
</style>

</head>
<body>
	Message: ${message}
	<div id="gantt_here" style='width:110%; height:400px;'></div>
    <script type="text/javascript">
		var tasks = {
					data:[
						{id:1, text:"Project #1",start_date:"01-11-2015", duration:11,
						progress: 0.6, open: true, holder: "ranga"},
						{id:2, text:"Task #1",   start_date:"03-11-2015", duration:5, 
						progress: 1,   open: true, parent:1},
						{id:3, text:"Task #2",   start_date:"02-11-2015", duration:7, 
						progress: 0.5, open: true, parent:1},
						{id:4, text:"Task #2.1", start_date:"03-11-2015", duration:2, 
						progress: 1,   open: true, parent:3},
						{id:5, text:"Task #2.2", start_date:"11-11-2015", duration:3, 
						progress: 0.8, open: true, parent:3},
						{id:6, text:"Task #2.3", start_date:"05-11-2015", duration:4, 
						progress: 0.2, open: true, parent:3}
					],
					links:[
						{id:1, source:1, target:2, type:"1"},
						{id:2, source:1, target:3, type:"1"},
						{id:3, source:3, target:4, type:"1"},
						{id:4, source:4, target:5, type:"0"},
						{id:5, source:5, target:6, type:"0"}
					]
				};
/*				
gantt.config.scale_unit = "month";
gantt.config.subscales = [
	{unit:"day", step:1, date:"%j, %D" }
];
gantt.config.scale_height = 44;
gantt.config.date_scale = "%F, %Y";
*/

	gantt.config.start_date = new Date(2015, 10, 1);
	gantt.config.end_date = new Date(2015, 11, 31);
	gantt.config.scale_unit = "month";
	gantt.config.step = 1;
	gantt.config.date_scale = "%F, %Y";
	gantt.config.min_column_width = 30;
	gantt.config.start_on_monday = false;
	gantt.config.scale_height = 90;

	// one of these would work sort/ordering
	gantt.config.sort = false;
	gantt.config.order_branch = true;
	gantt.config.order_branch_free = true;

	
	var dayweekendFn = function(date){
		if(date.getDay()==0||date.getDay()==6){
			return "weekend";
		}
	};
	var taskweekendFn = function(item,date){
		if(date.getDay()==0||date.getDay()==6){ 
			return "weekend" ;
		}
	};

	var weekScaleTemplate = function(date){
		var dateToStr = gantt.date.date_to_str("%d %M");
		var endDate = gantt.date.add(gantt.date.add(date, 1, "week"), -1, "day");
		return dateToStr(date) + " - " + dateToStr(endDate);
	};

	//gantt.templates.scale_cell_class = dayweekendFn; 
	gantt.templates.task_cell_class = taskweekendFn;
	gantt.config.subscales = [
		{unit:"week", step:1, template:weekScaleTemplate},
		{unit:"day", step:1, date:"%D", css: dayweekendFn }
	];


	var date_to_str = gantt.date.date_to_str(gantt.config.task_date);
 
gantt.addMarker({
    start_date: new Date(), //a Date object that sets the marker's date
    css: "today", //a CSS class applied to the marker
    text: "Now", //the marker title
    title:date_to_str( new Date()) // the marker's tooltip
});
gantt.addMarker({
    start_date: new Date(2015,10,15), //a Date object that sets the marker's date
    css: "today", //a CSS class applied to the marker
    text: "Delivery", //the marker title
    title:date_to_str( new Date()) // the marker's tooltip
});
	
	
	// LIGHT BOX
	var opts = [{key:1, label:'Resource1'},{key:2, label:'Resource2'}];
	gantt.config.lightbox.sections = [
		{name:"description", height:38, map_to:"text", type:"textarea", focus:true},
		{name:"time", height:38, map_to:"start_date", type:"duration"},
		{name:"holder", height:38, map_to:"holder", type:"select", options: opts},
		{name:"parent", type:"parent", allow_root:"true", root_label:"No parent"}, 
		{name:"template", height:16, type:"template", map_to:"my_template"}, 
	];
	
	gantt.locale.labels.section_template = "Details";
 
gantt.attachEvent("onBeforeLightbox", function(id) {
    var task = gantt.getTask(id);
    task.my_template = "<span id='title1'>Holders: </span> "+ task.holder
    +"<span id='title2'>Progress: </span>"+ task.progress*100 +" %";
    return true;
});
	
		// GRID
		gantt.config.grid_width = 500;
		var percentageFn = function(taskData){
			return taskData.progress*110+" %";
		}
		//default columns definition
		gantt.config.columns =  [
			{name:"text",       label:"Task name",  resize: true,	tree:true, width:"200px" },
			{name:"holder",     label:"Resource",   resize: true,	align: "center" },
			{name:"start_date", label:"Start time", resize: true,	align: "center" },
			{name:"end_date",   label:"End date",   resize: true,	align: "center" },
			{name:"progress",   label:"Progress",   resize: true,	align: "center",	template: percentageFn },
		];
		
        gantt.init("gantt_here");   
		gantt.parse (tasks);
    </script>
</body>

</html>
