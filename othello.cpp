#include<iostream>
using namespace std;

void print(int a[8][8]){
	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++){
			cout<<a[i][j]<<" ";
		}
		cout<<endl;
	}
}

int count(int a[8][8]){
	int i,j,x=0,y=0;
	for(i=0;i<8;i++){
		for(j=0;j<8;j++){
			if(a[i][j]==1)
				x++;
			else if(a[i][j]==2)
				y++;
		}
	}

	if(x>y)
		return 1;
	else if(x<y)
		return 2;
	else
		return 0;
}

bool dircheck(int a[8][8],int x,int y,int dx,int dy,int p,int q){
	if(x+dx<0 || x+dx>7 || y+dy<0 || y+dy>7 || a[y+dy][x+dx]==0)
		return false;
	else if(a[y+dy][x+dx]==q)
		dircheck(a,x+dx,y+dy,dx,dy,p,q);

	if(a[y+dy][x+dx]==p){
		a[y][x]=p;
		return true;
	}

	return false;
}

bool isValid(int a[8][8],int p,int x,int y){
	if(x<0 || x>7 || y<0 || y>7 || a[y][x]!=0)
		return false;

	int q=3-p;

	for(int dy=-1;dy<2;dy++){
		for(int dx=-1;dx<2;dx++){
			if(dy==0 && dx==0)
				continue;

			if(x+dx<0 || x+dx>7 || y+dy<0 || y+dy>7 || a[y+dy][x+dx]!=q)
				continue;
			else if(dircheck(a,x+dx,y+dy,dx,dy,p,q)==true)
				a[y][x]=p;
		}
	}

	return (a[y][x]==p);
}

void copy(int a[8][8],int b[8][8]){
	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++)
			b[i][j]=a[i][j];
	}

	return;
}

bool possible(int a[8][8],int p){
	int b[8][8];
	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++){
			copy(a,b);
			if(isValid(b,p,i,j)==true)
				return true;
		}
	}

	return false;
}

int main(){
	int game[8][8]={0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,
					0,0,0,1,2,0,0,0,
					0,0,0,2,1,0,0,0,
					0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0
					};

	int p=1,q=2,miss=0,x,y;

	while(miss<2){
		if(possible(game,p)==true){
			print(game);
			miss=0; //the game will only end if no player has any move possible, if by mistake a player enters wrong move, the chance is passed.

			cout<<"enter x and y for player "<<p<<endl;
			cin>>x>>y;
			if(isValid(game,p,x,y)==false)
				cout<<"invalid move\n";
		}
		else{
			cout<<"player "<<p<<" has no choice\n";
			miss++;
		}

		q=p;
		p=3-p;
	}

	p=count(game);
	print(game);
	if(p==0)
		cout<<"draw\n";
	else
		cout<<"player "<<p<<" wins\n";

	return 0;
}