import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/presentation/ekskul/views/ekskul_detail.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/widgets/card_ekskul.dart';
import 'package:stacked_listview/stacked_listview.dart';

class EkskulScreen extends StatelessWidget {
  const EkskulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => EkskulCubit()..displayEkskul(),
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.07),
          child: BlocBuilder<EkskulCubit, EkskulState>(
            builder: (context, state) {
              if (state is EkskulLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is EkskulLoaded) {
                return StackedListView(
                  padding: EdgeInsets.only(
                    bottom: height * 0.15,
                  ),
                  itemExtent: width * 0.475,
                  itemCount: state.ekskul.length,
                  scrollDirection: Axis.horizontal,
                  builder: (context, index) {
                    return GestureDetector(
                      onTap: () => AppNavigator.push(
                        context,
                        EkskulDetail(
                          ekskul: state.ekskul[index],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 4,
                          right: index == state.ekskul.length - 1 ? 0 : 4,
                        ),
                        child: CardEkskul(
                          ekskul: state.ekskul[index],
                        ),
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
