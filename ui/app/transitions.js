export default function () {
  this.transition(
    this.toRoute('index'),
    this.use('toRight')
  );
  this.transition(
    this.fromRoute('index'),
    this.toRoute('flights'),
    this.use('toLeft')
  );
}
