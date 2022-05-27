Class I2B2.Utils [ Abstract, Language = objectscript ]
{

/// d ##class(I2B2.Utils).initNextvalValues()
ClassMethod initNextvalValues()
{
	s ^I2B2.Utils.NEXTVAL("qt_xml_result_xml_result_id_seq")=$o(^B5ms.BH3z.3(""),-1)+1
	s ^I2B2.Utils.NEXTVAL("qt_query_instance_query_instance_id_seq")=$o(^B5ms.EFUS.3(""),-1)+1
	s ^I2B2.Utils.NEXTVAL("qt_query_master_query_master_id_seq")=$o(^B5ms.CI7d.3(""),-1)+1
	s ^I2B2.Utils.NEXTVAL("qt_pdo_query_master_query_master_id_seq")=$o(^B5ms.Bhao.3(""),-1)+1
	s ^I2B2.Utils.NEXTVAL("qt_query_result_instance_result_instance_id_seq")=$o(^B5ms.E6AR.3(""),-1)+1
}

ClassMethod nextval(key As %String) As %Integer [ SqlProc ]
{
	q $i(^I2B2.Utils.NEXTVAL(key))
}

Query GetPathOrder(pFullName As %String = "") As %Query(ROWSPEC = "c_name:%String,c_fullname:%String,c_hlevel:%Integer") [ SqlName = get_path_order, SqlProc ]
{
}

ClassMethod GetPathOrderExecute(ByRef qHandle As %Binary, pFullName As %String = "") As %Status
{
	
	Set tSQL="select c_name, c_fullname, '' As path from ""public"".I2B2 where c_fullname = ? and c_synonym_cd='N'"
	Set qHandle=##class(%ResultSet).%New()
	Do qHandle.Prepare(tSQL)
	Do qHandle.Execute(pFullName)
	i qHandle
	Quit $$$OK
}

ClassMethod GetPathOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ServicesExecute ]
{
	Quit $$$OK
}

ClassMethod GetPathOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ServicesExecute ]
{
	Set Row=""
	s hlevel=1

	i $g(qHandle.Data("c_fullname"))="" {
		If 'qHandle.Next() Set AtEnd=1 Quit $$$OK
	}
	s fullname=$g(qHandle.Data("c_fullname"))
	s path=$g(qHandle.Data("path"))
	s name=$g(qHandle.Data("c_name"))
	s hlevel=1
	i fullname'="" {
		s len1=$l(path, "\")-2 s:len1<1 len1=0
		s len2=$l(fullname, "\")-2
		f index=len1+1:1:len2 {
			s hlevel = len2-index+1
			i index=len2 {
				s name=$g(qHandle.Data("c_name"))
				s path=fullname
				s qHandle.Data("c_fullname")=""  // we need to make qHandle.Next() next time
			} else {
				s name=""
				s path=$p(fullname,"\",1, index+1)_"\"
				&sql(select c_name into:name from "public".I2B2 where c_fullname = :path and c_synonym_cd='N')
			}
			q:$g(name)'=""
		}
		s qHandle.Data("path")=path
	} 
	
	Set Row=$lb(name,path,hlevel)	
	Quit $$$OK
}

}
