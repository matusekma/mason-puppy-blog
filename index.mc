<%class>
  has 'category_id';
  has 'all_unpublished';
</%class>



<& puppyList.mi, category_id => $.category_id, all_unpublished => $.all_unpublished &>