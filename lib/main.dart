import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController totalPalitosController = TextEditingController();
  TextEditingController limitePalitosController = TextEditingController();
  TextEditingController moveController = TextEditingController();
  String outputText = "";
  int numberOfPieces = 0;
  int limit = 0;
  bool computerPlay = false;
  List<String> moveHistory = [];

  @override
  void initState() {
    super.initState();
  }

  void startGame() {
    numberOfPieces = int.tryParse(totalPalitosController.text) ?? 0;
    limit = int.tryParse(limitePalitosController.text) ?? 0;

    if (numberOfPieces < 2) {
      setState(() {
        outputText = 'Quantidade de palitos inválida! Informe um valor maior ou igual a 2.\n';
      });
      return;
    }

    if (limit <= 0 || limit >= numberOfPieces) {
      setState(() {
        outputText = 'Limite de palitos inválido! Informe um valor maior que zero e menor que o total de palitos.\n';
      });
      return;
    }

    setState(() {
      outputText = "";
      computerPlay = (numberOfPieces % (limit + 1)) == 0;
    });

    if (!computerPlay) {
      userPlay();
    } else {
      computerMove();
    }
  }

  void userPlay() {
    setState(() {
      outputText = "Sua vez. Quantos palitos você vai tirar? (1 a $limit)";
    });
  }

  void updateGame(int move) {
    setState(() {
      numberOfPieces -= move;
      moveHistory.add("Você tirou $move palito(s). Restam $numberOfPieces palitos.");
      if (numberOfPieces == 1) {
        endGame();
      } else {
        computerPlay = !computerPlay;
        if (computerPlay) {
          computerMove();
        } else {
          userPlay();
        }
      }
    });
  }

  void computerMove() {
    int computerMove = computerChoosesMove(numberOfPieces, limit);
    setState(() {
      numberOfPieces -= computerMove;
      moveHistory.add("O computador tirou $computerMove palito(s). Restam $numberOfPieces palitos.");

      computerPlay = !computerPlay;

      if (numberOfPieces == 1) {
        endGame();
      } else {
        userPlay();
      }
    });
  }

  int computerChoosesMove(int numberOfPieces, int limit) {
    int remainder = numberOfPieces % (limit + 1);
    if (remainder == 0) {
      return limit;
    } else {
      return (remainder - 1) == 0 ? limit : (remainder - 1);
    }

  }

  void endGame() {
    String result = computerPlay ? "Você ganhou!" : "O computador ganhou!";
    setState(() {
      moveHistory.add(result);
      moveHistory.add("Fim do jogo.\nObrigado por jogar :)");
    });
  }

  void restartGame() {
    setState(() {
      numberOfPieces = 0;
      limit = 0;
      outputText = "";
      moveHistory.clear();
    });
  }

  void processUserMove() {
    int move = int.tryParse(moveController.text) ?? 0;
    if (move < 1 || move > limit) {
      setState(() {
        moveHistory.add("\nJogada inválida. Tente novamente.\n");
      });
    } else {
      updateGame(move);
      setState(() {
        moveController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
        title: Text('Jogo Nim'),
        backgroundColor: Color.fromARGB(255, 3, 12, 63),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 120,
              child: DrawerHeader(
              decoration: BoxDecoration(
              color: Color.fromARGB(255, 3, 12, 63),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: 
                        Image.network(
                          'https://avatars.githubusercontent.com/u/105259264?s=400&u=6c804cd91b379e3b99372f6bba4e2d092c768add&v=4',
                          width: 60,
                          height: 60,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          Text('Dayane Sivil Moreira', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                          RichText(
                            text: TextSpan(
                              text: 'RA: 1431432312008',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: totalPalitosController,
                decoration: InputDecoration(labelText: 'Quantidade de palitos? (>= 2)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: limitePalitosController,
                decoration: InputDecoration(labelText: 'Limite de palitos por jogada? (> 0 e < total de palitos)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: startGame,
                      child: Text('Iniciar Jogo'),
                      style: ElevatedButton.styleFrom(
                      elevation: 20,
                      padding: const EdgeInsets.all(20),
                      primary:  Color.fromARGB(255, 3, 12, 63),
              ),
                      
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: restartGame,
                      child: Text('Reiniciar Jogo'),
                      style: ElevatedButton.styleFrom(
                      elevation: 20,
                      padding: const EdgeInsets.all(20),
                      primary:  Color.fromARGB(255, 3, 12, 63),
              ),
                    ),
                  ),
                ]
              ),
              SizedBox(height: 15),
              Text(
                outputText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Histórico de jogadas:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 3, 12, 63)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      itemCount: moveHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            moveHistory[index],
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextField(
                controller: moveController,
                decoration: InputDecoration(labelText: 'Sua jogada (1 a $limit)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: processUserMove,
                  child: Text('Enviar Jogada'),
                  style: ElevatedButton.styleFrom(
                    elevation: 20,
                    padding: const EdgeInsets.all(20),
                    primary: Color.fromARGB(255, 3, 12, 63),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
