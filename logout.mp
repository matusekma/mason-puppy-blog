method handle() {
	  $m->session->{user_id} = -1;
    $m->redirect('/wae01/index');
}