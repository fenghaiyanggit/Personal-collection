<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.Map" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html>
	<head>
		<title>日报报表</title>
	</head>
	<body>
		<input type="button" disabled="true" value="部门">
		<span style="width: 120px;height: 23px;">
			<select name="bm" id="bm">
				<option value="">-----选择部门------</option>
				<%
                  String sql = "select id,departmentname,supdepid,subcompanyid1,ecology_pinyin_search from HrmDepartment";

                  RecordSet.executeSql(sql);

                  while (RecordSet.next()){
                      out.print("<option value='"+RecordSet.getInt("id")+"'>");
                      out.print(RecordSet.getString("departmentname"));
                      out.print("</option>");
                  }
              %>
			</select>
		</span>
		<input type="button" disabled="true" value="年份">
		<span style="width:120px;height:23px">
			<select name="nf" id="nf">
				<option value="0">-----选择年份------</option>
			</select>
		</span>
		<input type="button" disabled="true" value="月份">
		<span style="width:120px;height: 23px">
			<select name="yf" id="yf">
				<option value="0">-----选择月份-----</option>
			</select>
		</span>
		<input type="button" value="提交" onclick="tj()">

		<table border="1" cellspacing="0" bordercolor="#000000" width="80%" style="border-collapse:collapse;" id="tab">
			<thead>
				<tr>
					<th rowspan="2">序号</th>
					<th rowspan="2">姓名</th>
					<%
                int a=31;//循环次数
                for(int i=1;i<=a;i++){
                    out.print("<th colspan='3' style='background-color:white;' class='redClass"+i+"'>");
                    out.print(i+"日");
                    out.print("</th>");
                }
             %>
				</tr>
				<tr>
					<%
                for (int i=1;i<=a;i++){
                    out.print("<th style='background-color:white;' class='redClass"+i+"'>");
                    out.print("日报质量");
                    out.print("</th>");
                    out.print("<th style='background-color:white;' class='redClass"+i+"'>");
                    out.print("按时提交");
                    out.print("</th>");
                    out.print("<th style='background-color:white;' class='redClass"+i+"'>");
                    out.print("饱和度");
                    out.print("</th>");
                }
            %>
				</tr>
			</thead>
			<tbody>
			<%
             String id = Util.null2String(request.getParameter("id"));
             String departmentname = Util.null2String(request.getParameter("departmentname"));
             String thisnf = Util.null2String(request.getParameter("thisnf"));
             String thisyf = Util.null2String(request.getParameter("thisyf"));
             if (!id.equals("")&&!thisnf.equals("")&&!thisyf.equals("")){
                 String sSql ="select a.lastname userName,b.*,c.*,d.* from HrmResource a "
											+" left join GZXX_View_RiBaoGetbhdpj b on a.id=b.tbr and a.departmentid=b.tbbm "
											+" left join GZXX_View_RiBaoGetastj c on a.id=c.tbr and a.departmentid=c.tbbm and b.tbrqy = c.tbrqy and b.tbrqm =c.tbrqm "
											+" left join GZXX_View_RiBaoGetsjldsp d on a.id=d.tbr and a.departmentid=d.tbbm and b.tbrqy = d.tbrqy and b.tbrqm = d.tbrqm";
											 //left join mode_selectitempagedetail gg on gg.mainid=41 //饱和度表  //mainid=40日报质量
                 sSql+=" where b.tbbm ="+id+" and b.tbrqy="+thisnf+" and b.tbrqm="+thisyf+" and a.departmentid="+id;

                 RecordSet.executeSql(sSql);
								Integer indexNumber =1;
                 while(RecordSet.next()){
                     out.print("<tr>");
                     out.print("<td style=\"background-color:yellow;\">");
                     out.print(indexNumber);
                     out.print("</td>");
                     out.print("<td style=\"background-color:yellow;\">");
                     out.print(RecordSet.getString("userName"));
                     out.print("</td>");
                     for (int j=1;j<=31;j++){
                         out.print("<td style=\"background-color:yellow;\">");
                         out.print(RecordSet.getString("rbzl"+j));
                         out.print("</td>");

                         out.print("<td style=\"background-color:yellow;\">");
                         out.print(RecordSet.getString("astj"+j));
                         out.print("</td>");

                         out.print("<td style=\"background-color:yellow;\">");
                         out.print(RecordSet.getString("bhd"+j));
                         out.print("</td>");
                     }
                     out.print("</tr>");
										 indexNumber++;
                 }
             }
         %>
			</tbody>
		</table>
	</body>
	<script type="text/javascript">
		window.onload = function() {
			var year = new Date().getFullYear();
			var nf = document.getElementById('nf');
			var yf = document.getElementById('yf');
			//var bm=document.getElementById('bm');
			//初始化添加年份
			for (var i = year; i >= 2000; i--) {
				var option = document.createElement('option');
				option.value = i;
				var txt = document.createTextNode(i); //创建文本节点
				option.appendChild(txt);
				nf.appendChild(option);
			}
			//初始化添加月份
			for (var j = 1; j <= 12; j++) {
				var option = document.createElement('option');
				option.value = j;
				var txt = document.createTextNode(j);
				option.appendChild(txt);
				yf.appendChild(option);
			}


		//获取表格
		var id = getQueryVariable("id");
		var thisnf = getQueryVariable("thisnf");
		var thisyf = getQueryVariable("thisyf");
		if(thisnf!=false && thisyf != false){
			document.getElementById("bm").value = id;
			 document.getElementById("nf").value = thisnf;
			 document.getElementById("yf").value = thisyf;
			
			for (var k = 1; k < 32; k++) {
				document.getElementsByClassName("redClass"+k)[0].style.backgroundColor= "white";
				document.getElementsByClassName("redClass"+k)[1].style.backgroundColor= "white";
				document.getElementsByClassName("redClass"+k)[2].style.backgroundColor= "white";
				document.getElementsByClassName("redClass"+k)[3].style.backgroundColor= "white";
				//清空第一行所有列样式
				var rq = thisnf + "-" + thisyf + "-" + k;
				var tian = new Date(rq).getDay();
				if (tian == 6 || tian == 0) {
					document.getElementsByClassName("redClass"+k)[0].style.backgroundColor= "red";
					document.getElementsByClassName("redClass"+k)[1].style.backgroundColor= "red";
					document.getElementsByClassName("redClass"+k)[2].style.backgroundColor= "red";
					document.getElementsByClassName("redClass"+k)[3].style.backgroundColor= "red";
				}
			}
		}
			// CheckRequestState();
		};

		function tj() {
			//获取select对象
			var nf = document.getElementById("nf");
			var yf = document.getElementById("yf");
			var bm = document.getElementById("bm");
			//取得所中项的索引
			var indexnf = nf.selectedIndex;
			var indexyf = yf.selectedIndex;
			var indexbm = bm.selectedIndex;
			//获取年月选中项的文本内容
			var thisnf = nf.options[indexnf].text;
			var thisyf = yf.options[indexyf].text;
			var departmentname = bm.options[indexbm].text;
			//获取部门选中项的value
			var id = bm.options[indexbm].value;
	
			console.log("id=" + id + "年=" + thisnf + "月=" + thisyf);
			window.location.href = "ribaobaobiao.jsp?as=a&id=" + id + "&thisnf=" + thisnf + "&thisyf=" + thisyf + "";
		}


	</script>
</html>
