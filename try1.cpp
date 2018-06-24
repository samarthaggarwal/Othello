#include<iostream>
using namespace std;

void print(int a[8][8],int p){
	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++){
			cout<<a[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<"\nEnter y and x for Player "<<p<<endl;
}

bool dircheck(int a[8][8],int x,int y,int dx,int dy,int p,int q){
	x+=dx;
	y+=dy;
	if(x<0 && x>7 && y<0 && y>7)
		return false;
	else if(a[x][y]==0)
		return false;
	else if(a[x][y]==p)
		return true;
	else{
		if(dircheck(a,x,y,dx,dy,p,q)==true){
			a[x][y]=p;
			return true;
		}
		else
			return false;
	}
}

bool update(int a[8][8],int x,int y,int p){
	if(a[x][y]!=0)
		return false;
	
	bool flag=false;
	int q=3-p;
	bool f1;
	//print(a,p);

	//cout<<"p="<<p<<" q="<<q<<endl;
	for(int dx=-1;dx<=1;dx++){
		for (int dy=-1;dy<=1;dy++){
			f1=false;
			if(dx==0 &&dy==0)
				continue;
			//cout<<"check along dir "<<dx<<" "<<dy<<" \n";
			if(x+dx>=0 && x+dx<8 && y+dy>=0 && y+dy<8 && a[x+dx][y+dy]==q){
				//cout<<"inside if\n";
				f1 = dircheck(a,x,y,dx,dy,p,q);
				flag = flag || f1;
				//cout<<f1<<endl;
			}
			//cout<<f1<<" ";
		}
	}

	return flag;
}

void copy(int a[8][8],int b[8][8]){
	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++){
			b[i][j]=a[i][j];
		}
	}
}

bool possible(int a[8][8],int p){
	cout<<"hello\n";
	int b[8][8];
	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++){
			cout<<"checking i="<<i<<" j="<<j<<endl;
			if(a[i][j]==0){
				copy(a,b);
				if(update(b,i,j,p)==true){
					cout<<"possible at x="<<i<<" y="<<j<<endl;
					//return true;
				}
			}
		}
	}

	return false;
}

int main(){
/*	int game[8][8]={0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,
					0,0,0,1,2,0,0,0,
					0,0,1,1,1,0,0,0,
					0,0,2,1,0,0,0,0,
					0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0
					};
*/
	int game[8][8]={1,1,1,1,1,1,1,1,
					1,1,1,1,1,1,1,1,
					1,1,1,1,1,1,1,1,
					1,1,1,1,1,1,1,1,
					1,1,1,1,1,1,1,1,
					0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0
					};
	int p=1,x,y;
	bool p1,p2,p3,p4;

	do{
		cout<<"hi 1\n";
		p1=possible(game,1);
		if(p1){
			print(game,1);
			do{
				cin>>x>>y;
				p3=update(game,x,y,1);
				if(p3==true)
					game[x][y]=1;
				else
					cout<<"invalid move, player 1 try again\n\n";
			}while(p3==false);
		}
		else
			cout<<"Player 1 has no choice\n";

		cout<<"hi 2\n";
		p2=possible(game,2);
		cout<<"possible\n";
		if(p2){
			print(game,2);
			do{
				cin>>x>>y;
				p4=update(game,x,y,2);
				if(p4==true)
					game[x][y]=2;
				else
					cout<<"invalid move, player 2 try again\n\n";
			}while(p4==false);
		}
		else
			cout<<"Player 2 has no choice\n";
		
		cout<<"hi 3\n";
	}while(p1 || p2);

	x=y=0;
	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++){
			if(game[i][j]==1)
				x++;
			else if(game[i][j]==2)
				y++;
		}
	}

	if(x==y)
		cout<<"match draw";
	else{
		if(x>y)
			p=1;
		else
			p=2;
		cout<<"player "<<p<<" wins\n";
	}

	return 0;
}